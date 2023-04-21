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
      put_resp_header: 3,
      put_resp_content_type: 2,
      send_resp: 3
    ]

  require Logger

  @moduledoc """
  This plug can be used in a Phoenix controller to rate limit requests or in the router pipeline to rate limit all requests.
  """
  def init(options) do
    options
  end

  def call(conn, opts) do
    conn
    |> rate_limit(opts)
  end

  @doc """
  A function plug that implements rate limiting using ExRated

  ## Example

      # In a controller
      import SentrypeerWeb.RateLimitPlug, only: [rate_limit: 2]
      plug :rate_limit, max_requests: 5, interval_seconds: 10

  """
  def rate_limit(conn, opts \\ []) do
    interval_ms = Keyword.fetch!(opts, :interval_seconds) * 1000
    max_requests = Keyword.fetch!(opts, :max_requests)

    inspected = ExRated.inspect_bucket(bucket_name(conn), interval_ms, max_requests)

    case check_rate(conn, interval_ms, max_requests) do
      {:ok, count} ->
        add_rate_limit_headers(conn, count, elem(inspected, 2), interval_ms, max_requests)

      error ->
        Logger.info(rate_limit: error)
        render_error(conn)
    end
  end

  defp check_rate(conn, interval_ms, max_requests) do
    ExRated.check_rate(bucket_name(conn), interval_ms, max_requests)
  end

  # Bucket name should be a combination of IP address and request path.
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    # E.g., "127.0.0.1:/api/v1/example"
    Logger.debug("Rate Limit: bucket_name: #{ip}:#{path}")
    "#{ip}:#{path}"
  end

  # https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/
  defp add_rate_limit_headers(conn, count, ms_remaining, interval_ms, max_requests) do
    conn
    |> put_resp_header("RateLimit-Limit", "#{max_requests}")
    |> put_resp_header("RateLimit-Remaining", "#{max_requests - count}")
    # 1 hour
    |> put_resp_header("RateLimit-Reset", "#{ceil(ms_remaining / 1000)}")
    # 1 hour
    |> put_resp_header(
      "RateLimit-Policy",
      "#{max_requests};w=#{ceil(interval_ms / 1000)};policy=\"leaky bucket\""
    )
  end

  defp render_error(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(429, '{"status": "429 Too Many Requests"}')
    |> halt()
  end
end
