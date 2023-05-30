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

defmodule SentrypeerWeb.PricingController do
  use SentrypeerWeb, :controller

  alias Sentrypeer.BillingHelpers
  require Logger

  # Top Nav
  def index(conn, _params) do
    render(conn, :index,
      current_user: get_session(conn, :current_user),
      show_newsletter_subscription: false,
      page_title: "Pricing"
    )
  end

  def success(conn, %{"stripe_session_id" => stripe_session_id}) do
    case Stripe.Session.retrieve(stripe_session_id) do
      {:ok, session} ->
        {:ok, customer} = Stripe.Customer.retrieve(session.customer)
        Logger.debug(inspect(session))
        Logger.debug(inspect(customer))
        #
        #        subscription = List.first(customer.subscriptions.data)
        #        subscription_item = List.first(subscription.items.data)
        #        Logger.debug(inspect(customer))
        #        Logger.debug(inspect(subscription))
        #        Logger.debug(inspect(subscription_item))

        # Redirect to remove the "stripe_session_id" from the URL.
        conn
        |> put_flash(:info, "Thanks for becoming a SentryPeer customer #{customer.name}!")
        |> redirect(to: ~p"/pricing")

      {:error, error} ->
        Logger.error(inspect(error))

        conn
        |> put_flash(:info, "Thanks for becoming a SentryPeer customer!")
        |> redirect(to: ~p"/pricing")
    end
  end

  def cancel(conn, _params) do
    conn
    |> put_flash(:error, "Shame you didn't want to commit :-(")
    |> redirect(to: ~p"/pricing")
  end

  def new(conn, %{"product" => product}) do
    # Or if it is a recurring customer, you can provide customer_id
    # get_customer_from_email(email)
    customer_id = nil
    price_id = product
    quantity = 1
    success_url = url(~p"/pricing/new/success")

    # https://stripe.com/docs/api/checkout/sessions/create
    session_config = %{
      success_url: success_url <> "?stripe_session_id={CHECKOUT_SESSION_ID}",
      cancel_url: url(~p"/pricing/new/cancel"),
      mode: "subscription",
      line_items: [
        %{
          price: price_id,
          quantity: quantity
        }
      ],
      subscription_data: %{
        billing_cycle_anchor: BillingHelpers.first_of_next_month_unix()
      }
    }

    # Previous customer? customer_id else customer_email
    # The stripe API only allows one of {customer_email, customer}
    current_user = get_session(conn, :current_user)

    # Get them to sign up first, which puts them on the Tester plan
    if !current_user,
      do: redirect(conn, to: ~p"/signup") |> halt()

    session_config =
      if customer_id,
        do: Map.put(session_config, :customer, customer_id),
        else: Map.put(session_config, :customer_email, current_user.email)

    case Stripe.Session.create(session_config) do
      {:ok, session} ->
        redirect(conn, external: session.url)

      {:error, stripe_error} ->
        Logger.error("Stripe error: #{inspect(stripe_error)}")

        conn
        |> put_flash(:error, "Stripe error: #{inspect(stripe_error)}")
        |> redirect(to: ~p"/pricing")
    end
  end
end
