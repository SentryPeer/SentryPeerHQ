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

defmodule SentrypeerWeb.CustomerSettingsLive.Api.Overview do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.Auth.Auth0Config

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:token_url, Auth0Config.auth0_token_url())}
  end

  @impl true
  def handle_params(%{"client_id" => id}, _url, socket) do
    case Auth0ManagementAPI.get_client_for_user(socket.assigns.current_user.id, id) do
      nil ->
        {:noreply, socket |> assign(:page_title, "Node not found")}

      {:ok, client} ->
        {:noreply,
         socket
         |> assign(:page_title, "SentryPeer Node Overview")
         |> assign(:client, client)}

      {:error, _} ->
        {:noreply, redirect(socket, to: "/not_found")}
    end
  end
end
