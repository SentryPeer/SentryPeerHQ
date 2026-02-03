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

defmodule SentrypeerWeb.SentrypeerEventController do
  use SentrypeerWeb, :controller

  #  import SentrypeerWeb.RateLimitPlug, only: [rate_limit: 2]
  #  plug :rate_limit, max_requests: 30000, interval_seconds: 86400 # 1 day

  alias Sentrypeer.Alerts
  alias Sentrypeer.Auth.Auth0User
  alias Sentrypeer.SentrypeerEvents
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  require Logger

  action_fallback SentrypeerWeb.FallbackController

  def create(conn, sentrypeer_event_params) do
    with {:ok, %SentrypeerEvent{} = _sentrypeer_event} <-
           SentrypeerEvents.create_sentrypeer_event(
             sentrypeer_event_params,
             conn
           ) do
      conn
      |> put_status(:created)
      |> json(%{message: "Thanks for using SentryPeer!"})
    end
  end

  defp get_user_from_client_id(conn) do
    {:ok, auth_id} = Cachex.get(:sentrypeer_cache, "client_id:#{conn.assigns.client_id}")

    Logger.debug("get_user_from_client_id: #{auth_id}")

    %Auth0User{id: auth_id}
  end

  def check_phone_number(conn, %{"phone_number" => phone_number}) do
    auth0_user = get_user_from_client_id(conn)

    if FunWithFlags.enabled?(:contributor_plan, for: auth0_user) do
      check_phone_number_contributor_plan(conn, phone_number)
    else
      check_phone_number_paid_plan(conn, phone_number)
    end
  end

  defp check_phone_number_contributor_plan(conn, phone_number) do
    SentrypeerEvents.check_phone_number_exists_for_contributor?(
      phone_number,
      conn
    )
    |> check_phone_number_result(conn, phone_number)
  end

  defp check_phone_number_paid_plan(conn, phone_number) do
    SentrypeerEvents.check_phone_number_sentrypeer_event?(
      phone_number,
      conn
    )
    |> check_phone_number_result(conn, phone_number)
  end

  defp check_phone_number_result(result, conn, phone_number) do
    case result do
      true ->
        Alerts.send_alert(conn.assigns.client_id, phone_number)

        phone_number_found(conn)

      false ->
        phone_number_not_found(conn)
    end
  end

  def check_ip_address(conn, %{"ip_address" => ip_address}) do
    auth0_user = get_user_from_client_id(conn)

    if FunWithFlags.enabled?(:contributor_plan, for: auth0_user) do
      check_ip_address_contributor_plan(conn, ip_address)
    else
      check_ip_address_paid_plan(conn, ip_address)
    end
  end

  defp check_ip_address_contributor_plan(conn, ip_address) do
    SentrypeerEvents.check_ip_address_exists_for_contributor?(
      ip_address,
      conn
    )
    |> check_ip_address_result(conn, ip_address)
  end

  defp check_ip_address_paid_plan(conn, ip_address) do
    SentrypeerEvents.check_ip_address_sentrypeer_event?(
      ip_address,
      conn
    )
    |> check_ip_address_result(conn, ip_address)
  end

  defp check_ip_address_result(result, conn, ip_address) do
    case result do
      true ->
        Alerts.send_alert(conn.assigns.client_id, ip_address)

        ip_address_found(conn)

      false ->
        ip_address_not_found(conn)
    end
  end

  defp phone_number_found(conn) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Phone Number found."})
  end

  defp phone_number_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Phone Number not found."})
  end

  defp ip_address_found(conn) do
    conn
    |> put_status(:ok)
    |> json(%{message: "IP Address found."})
  end

  defp ip_address_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "IP Address not found."})
  end
end
