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

  alias Sentrypeer.BillingUtils
  require Logger

  # Top Nav
  def index(conn, _params) do
    render(conn, :index,
      current_user: get_session(conn, :current_user),
      show_newsletter_subscription: false,
      page_title: "Pricing"
    )
  end

  def success(conn, _params) do
    conn
    |> put_flash(:info, "Thanks for becoming a SentryPeer customer!")
    |> redirect(to: ~p"/pricing")
  end

  def cancel(conn, _params) do
    conn
    |> put_flash(:error, "Shame you didn't want to commit :-(")
    |> redirect(to: ~p"/pricing")
  end

  defp get_customer_from_email(email) do
    # TODO: Handle storing and retrieving customer_id
    # Is in the format
    # customer_id = "cus_xxxxxxxxxxxxxx"
    nil
  end

  def new(conn, %{"product" => product}) do
    # Or if it is a recurring customer, you can provide customer_id
    # get_customer_from_email(email)
    customer_id = nil
    # Get this from the Stripe dashboard for your product
    price_id = product
    quantity = 1

    session_config = %{
      success_url: url(~p"/pricing/new/success"),
      cancel_url: url(~p"/pricing/new/cancel"),
      mode: "subscription",
      line_items: [
        %{
          price: price_id,
          quantity: quantity
        }
      ],
      subscription_data: %{
        billing_cycle_anchor: BillingUtils.first_of_next_month_unix()
      }
    }

    # Previous customer? customer_id else customer_email
    # The stripe API only allows one of {customer_email, customer}
    current_user = get_session(conn, :current_user)

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
