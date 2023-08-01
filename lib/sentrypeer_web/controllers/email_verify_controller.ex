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

defmodule SentrypeerWeb.EmailVerifyController do
  use SentrypeerWeb, :controller

  alias Sentrypeer.Token
  require Logger

  action_fallback SentrypeerWeb.FallbackController

  def verify(conn, %{"token" => token}) do
    case Token.verify_token(token) do
      {:ok, payload} ->
        case Sentrypeer.Accounts.confirm_email(payload) do
          {:ok, user} ->
            render(conn, :verify_email,
              current_user: get_session(conn, :current_user),
              layout: false,
              show_newsletter_subscription: false,
              page_title: "Email Confirmed",
              verified: true
            )

          {:error, reason} ->
            render(conn, :verify_email,
              current_user: get_session(conn, :current_user),
              layout: false,
              show_newsletter_subscription: false,
              page_title: "Email Not Confirmed",
              verified: false
            )
        end

      {:error, reason} ->
        Logger.debug("Token verification failed: #{inspect(reason)}")

        render(conn, "error.html",
          current_user: get_session(conn, :current_user),
          layout: false,
          show_newsletter_subscription: false,
          page_title: "Email Not Confirmed",
          verified: false
        )
    end
  end
end
