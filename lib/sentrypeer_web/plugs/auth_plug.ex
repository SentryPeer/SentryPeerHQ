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

defmodule SentrypeerWeb.AuthPlug do
  import Plug.Conn
  use SentrypeerWeb, :controller

  @moduledoc """
  This plug is used to authenticate a user via their browser session.
  """

  def init(options) do
    options
  end

  def call(conn, opts) do
    conn
    |> authenticate_user(opts)
  end

  defp authenticate_user(conn, _opts) do
    user = get_session(conn, :current_user)

    case user do
      nil ->
        conn |> redirect(to: "/auth/auth0") |> halt()

      _ ->
        conn
        |> assign(:current_user, user)
    end
  end
end
