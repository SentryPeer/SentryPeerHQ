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

defmodule SentrypeerWeb.RateLimitPerPlanPlug do
  # See https://dev.to/mnishiguchi/rate-limiter-for-phoenix-app-3j2n

  import Plug.Conn,
    only: [
      get_req_header: 2,
      halt: 1,
      put_resp_header: 3,
      put_resp_content_type: 2,
      send_resp: 3
    ]

  alias Sentrypeer.Clients.Client
  alias Sentrypeer.Auth.Auth0User

  require Logger

  @moduledoc """
  This plug is used to check what plan the client is on and rate limit accordingly. We set the client_id
  in the 'conn' in the Auth.Authorize plug, then we look up the plan in the database with it.
  """
  def init(options) do
    options
  end

  def call(conn, opts) do
    conn
    |> check_who_owns_client_id(opts)
  end

  defp check_who_owns_client_id(conn, _opts) do
    client_id = conn.assigns.client_id

    case Sentrypeer.Clients.get_client_by_client_id!(client_id) do
      %Client{} = client ->
        check_what_plan_is_enabled(%Auth0User{id: client.auth_id})
        conn

      _ ->
        conn
        |> not_found()
    end
  end

  defp not_found(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, '{"status": "Client not found"}')
    |> halt()
  end

  defp check_what_plan_is_enabled(auth0_user) do
    case FunWithFlags.enabled?(:tester_plan, for: auth0_user) do
      true ->
        Logger.debug("Tester plan enabled")

      false ->
        Logger.debug("Tester plan disabled")
    end
  end

  @doc """
  A function plug that implements rate limiting using ExRated to rate limit per plan


  """
  def rate_limit_by_plan(conn, opts \\ []) do
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
    # /api/ip-addresses
    # /api/events
    # /api/phone-numbers etc.
    path = Enum.slice(conn.path_info, 0, 2) |> Enum.join("/")
    Logger.debug("Rate Limit path: #{path}")

    case get_req_header(conn, "fly-client-ip") do
      [] ->
        ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
        Logger.debug("Rate Limit on a normal IP: bucket_name: #{ip}:#{path}")
        "#{ip}:#{path}"

      client_ip ->
        Logger.debug("Rate Limit on Fly-Client-IP: bucket_name: #{client_ip}:#{path}")
        "#{client_ip}:#{path}"
    end
  end

  # https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/
  # Lowercase as per recommendation:
  #   https://hexdocs.pm/plug/Plug.Conn.html#put_resp_header/3
  defp add_rate_limit_headers(conn, count, ms_remaining, interval_ms, max_requests) do
    conn
    |> put_resp_header("ratelimit-limit", "#{max_requests}")
    |> put_resp_header("ratelimit-remaining", "#{max_requests - count}")
    # 1 hour
    |> put_resp_header("ratelimit-reset", "#{ceil(ms_remaining / 1000)}")
    # 1 hour
    |> put_resp_header(
      "ratelimit-policy",
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
