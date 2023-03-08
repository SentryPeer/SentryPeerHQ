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

defmodule SentrypeerWeb.AuthController do
  use SentrypeerWeb, :controller
  alias Sentrypeer.Accounts.UserFromAuth
  require Logger

  plug Ueberauth

  def login(conn, _params) do
    conn |> redirect(to: "/auth/auth0") |> halt
  end

  def signup(conn, _params) do
    conn |> redirect(to: "/auth/auth0?screen_hint=signup") |> halt
  end

  # See https://hexdocs.pm/phoenix_live_view/security-model.html#mounting-considerations
  def logout(conn, _params) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      Logger.debug("Logging out live socket: #{live_socket_id}")
      SentrypeerWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> put_flash(:info, "You have been logged out!")
    |> renew_session()
    |> redirect(external: Application.get_env(:sentrypeer, :auth0_logout_url))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> renew_session()
        |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        |> put_session(:live_socket_id, "users_socket:#{Base.url_encode64(user.id)}")
        |> redirect(to: "/dashboard")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> renew_session()
        |> redirect(to: "/")
    end
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
