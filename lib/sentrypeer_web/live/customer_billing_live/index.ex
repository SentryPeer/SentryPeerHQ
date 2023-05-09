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

defmodule SentrypeerWeb.CustomerBillingLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents
  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       # .avatar is in there too
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Billing"
     )}
  end

  @impl true
  def handle_event("manage_billing", _value, socket) do
    # Gavin's test customer
    customer_id = "cus_Npo2H16gMzkLpj"
    # customer_id = get_customer_from_email(email)

    case Stripe.BillingPortal.Session.create(%{
           customer: customer_id,
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
