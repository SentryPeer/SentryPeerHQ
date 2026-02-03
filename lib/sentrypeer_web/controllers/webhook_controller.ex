# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule SentrypeerWeb.WebhookController do
  use SentrypeerWeb, :controller

  action_fallback SentrypeerWeb.FallbackController

  def webhook_example(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
      type: "sentrypeer_webhook",
      subject: "Testing from SentryPeer",
      message: "Testing SentryPeer Webhook Integration",
      number_or_ip_address: "A match has been found!"
    })
  end

  def create_webhook_subscription(conn, %{"webhook" => webhook_params}) do
    with {:ok, %Sentrypeer.Integrations.Integration{}} <-
           Sentrypeer.Integrations.create_integration(webhook_params) do
      conn
      |> put_flash(:info, "Webhook subscription created successfully.")
      |> redirect(to: Routes.integration_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Error creating webhook subscription.")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete_webhook_subscription(conn, %{"id" => id}) do
    # Validate that they own the integration
    case Sentrypeer.Integrations.get_integration!(id) do
      %Sentrypeer.Integrations.Integration{} = integration ->
        Sentrypeer.Integrations.delete_integration(integration)

        conn
        |> put_flash(:info, "Webhook subscription deleted successfully.")
        |> redirect(to: Routes.integration_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Error deleting webhook subscription.")
        |> redirect(to: Routes.integration_path(conn, :index))
    end
  end
end
