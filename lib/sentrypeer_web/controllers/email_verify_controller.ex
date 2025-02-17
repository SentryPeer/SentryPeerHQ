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

defmodule SentrypeerWeb.EmailVerifyController do
  use SentrypeerWeb, :controller

  alias Sentrypeer.Integrations
  alias Sentrypeer.Integrations.Integration
  alias Sentrypeer.Token

  require Logger

  action_fallback SentrypeerWeb.FallbackController

  def verify(conn, %{"token" => token}) do
    case Token.verify_token(token) do
      {:ok, payload} ->
        Logger.debug("Token verification succeeded: #{inspect(payload)}")

        case Integrations.get_integration!(payload) do
          %Integration{} = integration ->
            Integrations.update_integration(integration, %{verified: true})

            render(conn, :verify_email,
              page_title: "Email Confirmed",
              verified: true
            )

          {:error, reason} ->
            render(conn, :verify_email,
              page_title: "Email Not Confirmed",
              verified: false,
              reason: reason
            )
        end

      {:error, reason} ->
        Logger.debug("Token verification failed: #{inspect(reason)}")

        render(conn, "error.html",
          page_title: "Email Not Confirmed",
          reason: reason
        )
    end
  end
end
