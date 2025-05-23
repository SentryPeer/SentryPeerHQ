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

defmodule Sentrypeer.Alerts do
  alias Sentrypeer.Accounts
  alias Sentrypeer.Alerts.Email
  alias Sentrypeer.Alerts.Slack
  alias Sentrypeer.Alerts.Webhook
  alias Sentrypeer.Clients.Client
  alias Sentrypeer.Integrations.Integration
  require Logger

  @moduledoc """
  Find the right alerting integration and send the alert.
  """

  def send_alert(client_id, number_or_ip_address) do
    case get_integrations_from_client(client_id) do
      {:error, _} ->
        {:error, "Client not found"}

      integrations ->
        Enum.each(integrations, fn %Integration{} = integration ->
          send_alert_based_on_type(integration, number_or_ip_address)
        end)
    end
  end

  defp send_alert_based_on_type(%Integration{type: "email"} = integration, number_or_ip_address) do
    Email.send_alert(integration, number_or_ip_address)
  end

  defp send_alert_based_on_type(%Integration{type: "slack"} = integration, number_or_ip_address) do
    Slack.send_alert(integration, number_or_ip_address)
  end

  defp send_alert_based_on_type(%Integration{type: "webhook"} = integration, number_or_ip_address) do
    Webhook.send_alert(integration, number_or_ip_address)
  end

  defp send_alert_based_on_type(%Integration{type: _} = integration, _number_or_ip_address) do
    Logger.error("Unknown integration type: #{integration.type}")
  end

  defp get_integrations_from_client(client_id) do
    case Sentrypeer.Clients.get_client_by_client_id!(client_id) do
      %Client{} = client ->
        Accounts.get_user_by_auth_id_with_integrations(client.auth_id).integrations

      _ ->
        {:error, "Client not found"}
    end
  end

  def post_headers do
    [
      Accept: "application/json; Charset=utf-8",
      "Content-Type": "application/json"
    ]
  end

  def post_options do
    [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 2000]
  end
end
