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

defmodule SentrypeerWeb.CustomerNodesLive.Index do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.CustomerClients.Client

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents
  require Logger

  @client_type "node_client"

  @impl true
  def mount(_params, session, socket) do
    if FunWithFlags.enabled?(:contributor_plan, for: session["current_user"]) do
      {:ok,
       socket
       |> assign(
         current_user: session["current_user"],
         app_version: Application.spec(:sentrypeer, :vsn),
         git_rev: Application.get_env(:sentrypeer, :git_rev),
         page_title: "Nodes" <> " · SentryPeer",
         meta_description: "SentryPeer Nodes list",
         client_type: "node_client"
       )
       |> stream_configure(:clients, dom_id: & &1.client_id)
       |> stream(:clients, list_clients(session["current_user"].id, @client_type), reset: true)}
    else
      {:ok, redirect(socket, to: "/not_found")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    Logger.debug("handle_params: #{inspect(params)}")
    Logger.debug("live_action: #{inspect(socket.assigns.live_action)}")

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"client_id" => id}) do
    case Auth0ManagementAPI.get_client_for_user(socket.assigns.current_user.id, id) do
      nil ->
        socket |> assign(:page_title, "Node not found")

      {:ok, client} ->
        socket
        |> assign(:page_title, "Edit Node")
        |> assign(:client, client)
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create a new SentryPeer Node")
    |> assign(:client_type, "node_client")
    |> assign(:client, %Client{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "SentryPeer Nodes")
    |> assign(:client, nil)
  end

  @impl true
  def handle_info({SentrypeerWeb.Live.APIClientFormComponent, {:saved, client}}, socket) do
    {:noreply,
     socket
     |> stream_insert(:clients, Auth0ManagementAPI.client_json_to_client_struct(client))
     |> assign(:client, client)}
  end

  @impl true
  def handle_event("delete", %{"client_id" => id}, socket) do
    case delete_node(socket.assigns.current_user.id, id) do
      {:ok, _} ->
        {:noreply, stream_delete(socket, :clients, id)}

      {:error, _} ->
        {:noreply, socket |> push_event("error", "Client not deleted")}
    end
  end

  defp list_clients(user, @client_type) do
    case Auth0ManagementAPI.list_clients_by_user(user, @client_type) do
      {:ok, clients} ->
        clients

      {:error, error} ->
        Logger.debug("Error in list_clients: #{inspect(error)}")
        []
    end
  end

  defp delete_node(user, id) do
    case Auth0ManagementAPI.delete_client_for_user(user, id) do
      {:ok, _} ->
        {:ok, "Node deleted"}

      {:error, _} ->
        {:error, "Node not deleted"}
    end
  end
end
