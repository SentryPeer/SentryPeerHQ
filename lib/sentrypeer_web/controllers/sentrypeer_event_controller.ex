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

defmodule SentrypeerWeb.SentrypeerEventController do
  use SentrypeerWeb, :controller

  #  import SentrypeerWeb.RateLimitPlug, only: [rate_limit: 2]
  #  plug :rate_limit, max_requests: 30000, interval_seconds: 86400 # 1 day

  alias Sentrypeer.SentrypeerEvents
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  #  alias Sentrypeer.Emails.EmailNotification
  #  alias Sentrypeer.Mailer

  action_fallback SentrypeerWeb.FallbackController

  def create(conn, sentrypeer_event_params) do
    with {:ok, %SentrypeerEvent{} = _sentrypeer_event} <-
           SentrypeerEvents.create_sentrypeer_event(
             sentrypeer_event_params,
             conn.assigns.client_id
           ) do
      conn
      |> put_status(:created)
      |> json(%{message: "Thanks for using SentryPeer!"})
    end
  end

  def check_phone_number(conn, %{"phone_number" => phone_number}) do
    case SentrypeerEvents.check_phone_number_sentrypeer_event?(
           phone_number,
           conn.assigns.client_id
         ) do
      true ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Phone Number found."})

      false ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Phone Number not found."})
    end
  end

  def check_ip_address(conn, %{"ip_address" => ip_address}) do
    case SentrypeerEvents.check_ip_address_sentrypeer_event?(
           ip_address,
           conn.assigns.client_id
         ) do
      true ->
        conn
        |> put_status(:ok)
        |> json(%{message: "IP Address found."})

      false ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "IP Address not found."})
    end
  end

  # For associating a client to a user, not used yet.
  #  defp find_user_id_by_client_id(client_id) do
  #    case Repo.get_by(User, client_id: client_id) do
  #      nil ->
  #        nil
  #
  #      user ->
  #        user
  #    end
  #  end

  #  defp send_email_alert(user, number_or_ip_address) do
  #    email = EmailNotification.voip_fraud_email_alert(user, number_or_ip_address)
  #    Mailer.deliver(email)
  #  end
end
