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

  alias Sentrypeer.Accounts
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

  def new(conn, %{"product" => _product}) do
    # Already logged in?
    current_user = get_session(conn, :current_user)

    # Get them to sign up first if not, which puts them on the Tester plan
    if !current_user,
      do: redirect(conn, to: ~p"/signup") |> halt()

    customer_id = Accounts.get_user_stripe_id(current_user.id).billing_subscription.stripe_id

    # If they are a customer, redirect to the Stripe Customer Billing Portal to allow
    # them to switch plan or cancel.
    if customer_id do
      case Stripe.BillingPortal.Session.create(%{
             customer: customer_id,
             return_url: url(~p"/billing")
           }) do
        {:ok, session} ->
          redirect(conn, external: session.url)

        {:error, stripe_error} ->
          Logger.error("Stripe error: #{inspect(stripe_error)}")

          conn
          |> put_flash(:error, "There's been an error, please try again.")
      end
    end
  end
end
