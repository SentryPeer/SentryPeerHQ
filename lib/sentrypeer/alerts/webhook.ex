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

defmodule Sentrypeer.Alerts.Webhook do
  alias Sentrypeer.Alerts
  alias Sentrypeer.Integrations.Integration

  require Logger

  @moduledoc """
  Send a Webhook alert.
  """

  def send_alert(%Integration{} = integration, number_or_ip_address) do
    case integration.enabled do
      true ->
        Logger.debug("Sending Webhook alert to #{integration.destination}")

        post_webhook(integration, number_or_ip_address)

      false ->
        Logger.debug("Webhook integration disabled.")

        {:ok, "Integration disabled."}
    end
  end

  defp to_json(integration, number_or_ip_address) do
    %{
      type: "sentrypeer_webhook",
      subject: "#{integration.subject}",
      message: "#{integration.message}",
      number_or_ip_address: "#{number_or_ip_address}"
    }
    |> Poison.encode!()
  end

  defp post_webhook(integration, number_or_ip_address) do
    Task.Supervisor.start_child(Sentrypeer.TaskSupervisor, fn ->
      case HTTPoison.post(
             integration.destination,
             to_json(integration, number_or_ip_address),
             Alerts.post_headers(),
             Alerts.post_options()
           ) do
        {:ok, res} ->
          Logger.debug("Webhook alert sent: #{inspect(res)}")

          {:ok, "Webhook alert sent."}

        {:error, error} ->
          Logger.debug("Webhook alert not sent: #{inspect(error)}")

          {:error, "Webhook alert not sent."}
      end
    end)
  end
end
