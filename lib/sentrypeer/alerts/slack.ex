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

defmodule Sentrypeer.Alerts.Slack do
  alias Sentrypeer.Alerts
  alias Sentrypeer.Integrations.Integration

  require Logger

  @moduledoc """
  Send a Slack alert.
  """

  def send_alert(%Integration{} = integration, number_or_ip_address) do
    case integration.enabled do
      true ->
        Logger.debug("Sending Slack alert to #{integration.destination}")

        send_to_slack(integration, number_or_ip_address)

      false ->
        Logger.debug("Slack integration disabled.")

        {:ok, "Integration disabled."}
    end
  end

  defp send_to_slack(integration, number_or_ip_address) do
    Task.Supervisor.start_child(Sentrypeer.TaskSupervisor, fn ->
      case HTTPoison.post(
             integration.destination,
             to_json(integration, number_or_ip_address),
             Alerts.post_headers(),
             Alerts.post_options()
           ) do
        {:ok, res} ->
          Logger.debug("Slack alert sent: #{inspect(res)}")

          {:ok, "Slack alert sent."}

        {:error, error} ->
          Logger.debug("Slack alert not sent: #{inspect(error)}")

          {:error, "Slack alert not sent."}
      end
    end)
  end

  defp to_json(integration, number_or_ip_address) do
    %{
      blocks: [
        %{
          type: "header",
          text: %{
            type: "plain_text",
            text: "#{integration.subject}"
          }
        },
        %{
          type: "section",
          fields: [
            %{
              type: "mrkdwn",
              text: "#{integration.message}"
            }
          ]
        },
        %{
          type: "section",
          fields: [
            %{
              type: "plain_text",
              text: "#{number_or_ip_address} has been seen."
            }
          ]
        }
      ]
    }
    |> Poison.encode!()
  end
end
