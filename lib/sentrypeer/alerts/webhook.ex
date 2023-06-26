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

defmodule Sentrypeer.Alerts.Webhook do
  alias Sentrypeer.Alerts

  require Logger

  @moduledoc """
  Send a Webhook alert.
  """

  def send_alert(integration, number_or_ip_address) do
    case integration.enabled do
      true ->
        Logger.debug("Sending Webhook alert to #{integration.url}")

        case HTTPoison.post(
               integration.url,
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

      false ->
        Logger.debug("Webhook integration disabled.")

        {:ok, "Integration disabled."}
    end
  end

  defp to_json(integration, number_or_ip_address) do
    %{
      "#{integration.subject}": "#{integration.message} #{number_or_ip_address} has been seen."
    }
    |> Poison.encode!()
  end
end
