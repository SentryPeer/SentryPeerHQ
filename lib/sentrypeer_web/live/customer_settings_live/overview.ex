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

defmodule SentrypeerWeb.CustomerSettingsLive.Overview do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0Config
  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.SentrypeerEvents

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       token_url: Auth0Config.auth0_token_url(),
       page_title: "SentryPeer API Client Overview",
       meta_description: "SentryPeer API Client Overview"
     )
     |> stream(:api_queries, [])}
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
         |> assign(:page_title, "SentryPeer API Client Overview")
         |> assign(:client, client)}

      {:error, _} ->
        {:noreply, redirect(socket, to: "/not_found")}
    end
  end

  @impl true
  def handle_info({api_query, conn, client_id}, socket) do
    Logger.debug("Client #{client_id} has just searched something.")

    {:noreply,
     stream_insert(socket, :api_queries, %{
       id: System.unique_integer(),
       query: api_query,
       conn: conn
     })}
  end
end
