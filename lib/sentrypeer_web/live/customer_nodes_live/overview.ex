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

defmodule SentrypeerWeb.CustomerNodesLive.Overview do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0Config
  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.SentrypeerEvents

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    node_probes = []

    {:ok,
     assign(socket,
       token_url: Auth0Config.auth0_token_url(),
       node_probes: node_probes
     )}
  end

  @impl true
  def handle_params(%{"client_id" => client_id}, _url, socket) do
    if connected?(socket), do: SentrypeerEvents.subscribe(client_id)

    case Auth0ManagementAPI.get_client_for_user(socket.assigns.current_user.id, client_id) do
      nil ->
        {:noreply, socket |> assign(:page_title, "Node not found")}

      {:ok, client} ->
        {:noreply,
         socket
         |> assign(:page_title, "SentryPeer Node Overview")
         |> assign(:client, client)
         |> assign(
           :total_unique_phone_numbers,
           total_unique_phone_numbers_for_client(client.client_id)
         )
         |> assign(
           :total_unique_ip_addresses,
           total_unique_ip_addresses_for_client(client.client_id)
         )
         |> assign(:total_events, total_events_for_client(client.client_id))}

      {:error, _} ->
        {:noreply, redirect(socket, to: "/not_found")}
    end
  end

  defp total_unique_phone_numbers_for_client(client_id) do
    Sentrypeer.SentrypeerEvents.total_unique_phone_numbers_for_client!(client_id)
  end

  defp total_unique_ip_addresses_for_client(client_id) do
    Sentrypeer.SentrypeerEvents.total_unique_ip_addresses_for_client!(client_id)
  end

  defp total_events_for_client(client_id) do
    Sentrypeer.SentrypeerEvents.total_events_for_client!(client_id)
  end

  @impl true
  def handle_info({node_probe, client_id}, socket) do
    Logger.debug("Client #{client_id} has just searched something.")
    node_searches = socket.assigns.node_probes ++ [node_probe]

    {:noreply,
     assign(socket,
       node_probes: node_searches,
       total_unique_phone_numbers: total_unique_phone_numbers_for_client(client_id),
       total_unique_ip_addresses: total_unique_ip_addresses_for_client(client_id),
       total_events: total_events_for_client(client_id)
     )}
  end
end
