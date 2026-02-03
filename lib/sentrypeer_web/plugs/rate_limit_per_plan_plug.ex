# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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
      put_resp_content_type: 2,
      send_resp: 3
    ]

  alias Sentrypeer.Clients.Client
  alias Sentrypeer.Plans
  alias Sentrypeer.Plans.Plan
  alias SentrypeerWeb.RateLimitPlug

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
        case check_what_plan_is_enabled(client.auth_id) do
          %Plan{} = plan ->
            Cachex.put(:sentrypeer_cache, "client_id:#{client_id}", client.auth_id)

            conn
            |> rate_limit_by_plan(
              interval_seconds: plan.rate_limit_period,
              max_requests: plan.rate_limit
            )

          _ ->
            conn
            |> not_found()
        end

      _ ->
        conn
        |> not_found()
    end
  end

  defp check_what_plan_is_enabled(auth0_user) do
    case Plans.what_plan_am_i_on(auth0_user) do
      [%Plan{}] = plan ->
        Logger.debug("Plan for #{inspect(auth0_user)} is #{inspect(plan)}")
        Enum.at(plan, 0)

      _ ->
        Logger.info("No plan found for #{inspect(auth0_user)}")
        []
    end
  end

  @doc """
  A function plug that implements rate limiting using ExRated to rate limit per plan


  """
  def rate_limit_by_plan(conn, opts \\ []) do
    interval_ms = Keyword.fetch!(opts, :interval_seconds) * 1000
    max_requests = Keyword.fetch!(opts, :max_requests)

    inspected = ExRated.inspect_bucket(bucket_name_per_client(conn), interval_ms, max_requests)

    case check_rate(conn, interval_ms, max_requests) do
      {:ok, count} ->
        RateLimitPlug.add_rate_limit_headers(
          conn,
          count,
          elem(inspected, 2),
          interval_ms,
          max_requests
        )

      {:error, count} ->
        Logger.info("Rate limit exceeded for #{inspect(bucket_name_per_client(conn))}")

        RateLimitPlug.add_rate_limit_headers(
          conn,
          count,
          elem(inspected, 2),
          interval_ms,
          max_requests
        )
        |> RateLimitPlug.render_error()
    end
  end

  defp check_rate(conn, interval_ms, max_requests) do
    ExRated.check_rate(bucket_name_per_client(conn), interval_ms, max_requests)
  end

  defp bucket_name_per_client(conn) do
    path = Enum.slice(conn.path_info, 0, 2) |> Enum.join("/")
    Logger.debug("Rate Limit path: #{path}")

    case get_req_header(conn, "fly-client-ip") do
      [] ->
        ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

        Logger.debug(
          "Rate Limit on a normal IP: bucket_name: client_id:#{conn.assigns.client_id}:#{ip}:#{path}"
        )

        "client_id:#{conn.assigns.client_id}:#{ip}:#{path}"

      client_ip ->
        Logger.debug(
          "Rate Limit on Fly-Client-IP: bucket_name: client_id:#{conn.assigns.client_id}:#{client_ip}:#{path}"
        )

        "client_id:#{conn.assigns.client_id}:#{client_ip}:#{path}"
    end
  end

  defp not_found(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, ~c"{\"status\": \"404 Client not found\"}")
    |> halt()
  end
end
