# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2024 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.Auth.ValidatePermission do
  @moduledoc """
  Plug for validating permissions on endpoints
  """
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  require Logger

  @spec init(any) :: any
  def init(default), do: default

  @doc """
  Checks whether the right permission is present in the permissions claim
  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, authorized_permissions) do
    Logger.debug("Validating permissions: #{inspect(conn.assigns.claims)}")

    if validate_permission(conn, authorized_permissions) do
      conn
    else
      handle_error_response(conn)
    end
  end

  defp validate_permission(
         %{assigns: %{claims: %{"permissions" => token_permissions}}},
         authorized_permissions
       )
       when is_list(token_permissions) do
    not MapSet.disjoint?(MapSet.new(token_permissions), authorized_permissions)
  end

  defp validate_permission(_conn, _permission), do: false

  defp handle_error_response(conn) do
    conn
    |> put_status(403)
    |> json(%{
      error: "insufficient_permissions",
      error_description: "Insufficient claim for the token",
      message: "Permission denied. Are you using the correct client_id to generate your token?"
    })
    |> halt()
  end
end
