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

defmodule Sentrypeer.Auth.Authorize do
  @moduledoc """
  Plug for authorizing endpoints using Bearer authorization token.
  """
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  require Logger

  alias Sentrypeer.Auth.Token

  @spec init(any) :: any
  def init(default), do: default

  @doc """
  Extracts the Bearer token from the authorization header and verifies the claims.
  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _default) do
    with {:ok, token} when is_binary(token) <- get_token(conn),
         {:ok, claims} <- Token.verify_and_validate(token) do
      # Used to identify the client to a user via Auth0 Management API
      # and for permissions.
      conn
      |> assign(:client_id, claims["azp"])
      |> assign(:claims, claims)
    else
      {:error, error} -> handle_error_response(conn, error)
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      ["bearer " <> token] -> {:ok, token}
      [] -> {:error, :missing_token}
      ["Bearer"] -> {:error, :invalid_token}
      _ -> {:error, :invalid_token}
    end
  end

  defp handle_error_response(conn, error) do
    if is_atom(error) do
      conn
      |> put_status(401)
      |> json(%{error: error})
      |> halt()
    else
      conn
      |> put_status(401)
      |> json(%{error: error[:message], reason: error[:claim]})
      |> halt()
    end
  end
end
