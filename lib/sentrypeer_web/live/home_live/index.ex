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

defmodule SentrypeerWeb.HomeLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.HomePageComponents
  alias Sentrypeer.Newsletter
  alias Sentrypeer.SentrypeerEvents

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: SentrypeerEvents.subscribe_all_nodes()

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       page_title: "SentryPeer® - Fraud Detection for VoIP",
       meta_description: "Use SentryPeer® to detect and prevent VoIP fraud.",
       show_newsletter_subscription: true,
       live_action: :index,
       total_unique_phone_numbers: total_unique_phone_numbers(),
       total_unique_ip_addresses: total_unique_ip_addresses(),
       total_events: total_events()
     )}
  end

  defp total_unique_phone_numbers do
    Sentrypeer.SentrypeerEvents.total_unique_phone_numbers!()
  end

  defp total_unique_ip_addresses do
    Sentrypeer.SentrypeerEvents.total_unique_ip_addresses!()
  end

  defp total_events do
    Sentrypeer.SentrypeerEvents.total_events!()
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("subscribe", %{"email" => email_address}, socket) do
    subscribe(socket, socket.assigns.live_action, email_address)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:email, nil)
  end

  defp subscribe(socket, :index, email_address) do
    Newsletter.subscribe(email_address)

    {:noreply,
     socket
     |> put_flash(:info, "Subscribe request received. Thank you!")}
  end

  @impl true
  def handle_info({:ok}, socket) do
    {:noreply,
     assign(socket,
       total_unique_phone_numbers: total_unique_phone_numbers(),
       total_unique_ip_addresses: total_unique_ip_addresses(),
       total_events: total_events()
     )}
  end
end
