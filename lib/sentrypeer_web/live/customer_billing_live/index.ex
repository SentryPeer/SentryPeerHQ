# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule SentrypeerWeb.CustomerBillingLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents
  import Sentrypeer.BillingHelpers

  alias Sentrypeer.Accounts
  alias Sentrypeer.BillingSubscriptions
  alias Stripe.BillingPortal.Session

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    subscription = get_subscription(session["current_user"])

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Billing" <> " · SentryPeer",
       meta_description: "SentryPeer Billing tools",
       subscription: subscription,
       subscription_item: List.first(subscription.items.data),
       billing_email: BillingSubscriptions.get_billing_email(session["current_user"].id),
       invoices: BillingSubscriptions.get_invoices(session["current_user"].id),
       upcoming_invoice: BillingSubscriptions.get_upcoming_invoice(session["current_user"].id),
       payment_methods: BillingSubscriptions.get_payment_methods(session["current_user"].id)
     )}
  end

  defp get_subscription(current_user) do
    List.first(BillingSubscriptions.get_subscription_from_stripe(current_user.id).data)
  end

  @impl true
  def handle_event("manage_billing", _value, socket) do
    case Session.create(%{
           customer:
             Accounts.get_user_stripe_id(socket.assigns.current_user.id).billing_subscription.stripe_id,
           return_url: url(~p"/billing")
         }) do
      {:ok, session} ->
        {:noreply, socket |> redirect(external: session.url)}

      {:error, stripe_error} ->
        Logger.error("Stripe error: #{inspect(stripe_error)}")

        {:noreply,
         socket
         |> put_flash(:error, "There's been an error, please try again.")}
    end
  end
end
