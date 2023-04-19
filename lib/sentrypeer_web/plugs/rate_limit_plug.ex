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

defmodule SentrypeerWeb.RateLimitPlug do
  @moduledoc false

  # See https://dev.to/mnishiguchi/rate-limiter-for-phoenix-app-3j2n

  import Plug.Conn,
    only: [
      halt: 1,
      merge_resp_headers: 2,
      put_status: 2,
      put_resp_header: 3,
      put_resp_content_type: 2,
      send_resp: 3
    ]

  import Phoenix.Controller, only: [render: 2]
  require Logger

  @doc """
  A function plug that implements rate limiting using ExRated.

  ## Examples

      # In a controller
      import SentrypeerWeb.RateLimitPlug, only: [rate_limit: 2]
      plug :rate_limit, max_requests: 5, interval_seconds: 10

  """
  def rate_limit(conn, opts \\ []) do
    case check_rate(conn, opts) do
      {:ok, count} ->
        add_rate_limit_headers(conn, count)

      error ->
        Logger.info(rate_limit: error)
        render_error(conn)
    end
  end

  defp check_rate(conn, opts) do
    interval_ms = Keyword.fetch!(opts, :interval_seconds) * 1000
    max_requests = Keyword.fetch!(opts, :max_requests)
    ExRated.check_rate(bucket_name(conn), interval_ms, max_requests)
  end

  # Bucket name should be a combination of IP address and request path.
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    # E.g., "127.0.0.1:/api/v1/example"
    "#{ip}:#{path}"
  end

  defp add_rate_limit_headers(conn, count) do
    conn
    |> put_resp_header("X-SentryPeer-API-RateLimit-Limit", "600")
    |> put_resp_header("X-SentryPeer-API-RateLimit-Remaining", "#{600 - count}")
    # 1 hour
    |> put_resp_header("X-SentryPeer-API-RateLimit-TimeToReset", "60")
    # 1 hour
    |> put_resp_header("X-SentryPeer-API-RateLimit-TimeToResetSecs", "3600")
  end

  defp render_error(conn) do
    conn
    |> merge_resp_headers([
      {"X-SentryPeer-API-RateLimit-Limit", "600"},
      {"X-SentryPeer-API-RateLimit-Remaining", "0"},
      # 1 hour
      {"X-SentryPeer-API-RateLimit-TimeToReset", "60"},
      # 1 hour
      {"X-SentryPeer-API-RateLimit-TimeToResetSecs", "3600"}
    ])
    |> put_resp_content_type("application/json")
    |> send_resp(429, '{"Status": "429 Too Many Requests"}')
    |> halt()
  end
end
