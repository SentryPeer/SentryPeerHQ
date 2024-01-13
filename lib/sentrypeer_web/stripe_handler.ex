# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>
#
#   _____            _              _____
#  / ____|          | |            |  __ \
# | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
#  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
#  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
# |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
#                              __/ |
#                             |___/
#

defmodule SentrypeerWeb.StripeHandler do
  @behaviour Stripe.WebhookHandler

  @moduledoc """
  This module is used to handle Stripe webhook events.
  """

  require Logger
  alias Sentrypeer.Accounts
  alias Sentrypeer.Auth.Auth0User
  alias Sentrypeer.BillingHelpers
  alias Sentrypeer.BillingSubscriptions

  @impl true
  def handle_event(%Stripe.Event{type: "invoice.paid"} = event) do
    Logger.debug("Payment Success.")
    Logger.debug(event)
    # Continue to provision the subscription as payments continue to be made.
    # Store the status in your database and check when a user accesses your service.
    # This approach helps you avoid hitting rate limits.
    :ok
  end

  @impl true
  def handle_event(%Stripe.Event{type: "invoice.payment_failed"} = event) do
    Logger.debug("Payment Failed.")
    Logger.debug(event)
    # The payment failed or the customer does not have a valid payment method.
    # The subscription becomes past_due. Notify your customer and send them to the
    # customer portal to update their payment information.
    :ok
  end

  @impl true
  def handle_event(%Stripe.Event{type: "checkout.session.completed"} = event) do
    Logger.debug("Checkout Session Completed.")
    Logger.debug(event)
    # Payment is successful and the subscription is created.
    # You should provision the subscription and save the customer ID to your database.
    :ok
  end

  @impl true
  # sobelow_skip ["DOS.StringToAtom"]
  def handle_event(%Stripe.Event{type: "customer.subscription.updated"} = event) do
    Logger.debug("Customer Subscription Updated.")
    Logger.debug(event)

    # Move into a subscription module etc.
    stripe_subscription = event.data.object
    stripe_id = event.data.object.customer

    subscription = BillingSubscriptions.get_subscription_by_stripe_id!(stripe_id)
    cancel_at = stripe_subscription.cancel_at || stripe_subscription.canceled_at
    canceled_at = stripe_subscription.canceled_at

    # Update the subscription in Pg
    BillingSubscriptions.update_billing_subscription(subscription, %{
      status: stripe_subscription.status,
      cancel_at: BillingHelpers.unix_to_naive_datetime(cancel_at),
      canceled_at: BillingHelpers.unix_to_naive_datetime(canceled_at),
      current_period_start:
        BillingHelpers.unix_to_naive_datetime(stripe_subscription.current_period_start),
      current_period_end_at:
        BillingHelpers.unix_to_naive_datetime(stripe_subscription.current_period_end)
    })

    # This is the struct type we currently use when a user is logged into the app.
    # need to clean this up and merge with Accounts.User
    account = Accounts.get_user_by_stripe_id!(stripe_id)
    user_for_flags = %Auth0User{id: account.user.auth_id}

    # Clear old plan and set the plan flag. This allows us to toggle functionality
    # based on the plan the user is on quickly for a demo etc.
    old_plan_nickname =
      (List.first(event.data.previous_attributes.items.data).plan.nickname <> "_plan")
      |> BillingHelpers.lowercase_spaces_to_underscores()
      |> String.to_existing_atom()

    FunWithFlags.clear(old_plan_nickname, for_actor: user_for_flags)

    new_plan_nickname =
      (List.first(stripe_subscription.items.data).plan.nickname <> "_plan")
      |> BillingHelpers.lowercase_spaces_to_underscores()
      |> String.to_existing_atom()

    FunWithFlags.enable(new_plan_nickname, for_actor: user_for_flags)

    :ok
  end

  # Return HTTP 200 for unhandled events
  @impl true
  def handle_event(event) do
    Logger.info("Unhandled Stripe Event: #{event.type}")
    :ok
  end
end
