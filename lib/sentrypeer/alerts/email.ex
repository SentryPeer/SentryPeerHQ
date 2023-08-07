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

defmodule Sentrypeer.Alerts.Email do
  import Swoosh.Email

  alias Sentrypeer.Integrations.Integration
  alias Sentrypeer.Mailer
  require Logger

  @moduledoc """
  Send an email alert.
  """

  def send_alert(%Integration{} = integration, number_or_ip_address) do
    case integration.enabled && integration.verified do
      true ->
        Logger.debug("Sending email alert to #{integration.destination}")

        new()
        |> to(integration.destination)
        |> from({"SentryPeer Alerts", "support@sentrypeer.com"})
        |> subject(integration.subject)
        |> html_body(
          integration.message <> "<br><br><b>#{number_or_ip_address}</b> has been seen."
        )
        |> text_body(
          integration.message <> "<br><br><b>#{number_or_ip_address}</b> has been seen."
        )
        |> Mailer.deliver()

      false ->
        Logger.debug("Email integration disabled.")

        {:ok, "Integration disabled"}
    end
  end
end
