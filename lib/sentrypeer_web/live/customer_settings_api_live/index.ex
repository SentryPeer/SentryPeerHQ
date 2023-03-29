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

defmodule SentrypeerWeb.CustomerSettingsApiLive.Index do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.CustomerNodes.Node

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents

  @impl true
  def mount(_params, session, socket) do
    nodes = list_clients(session["current_user"].id)

    {:ok,
     assign(socket,
       # .avatar is in there too
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Nodes",
       nodes: nodes
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"client_id" => id}) do
    case Auth0ManagementAPI.get_client_for_user(socket.assigns.current_user.id, id) do
      nil ->
        socket |> assign(:page_title, "Node not found")

      {:ok, node} ->
        socket
        |> assign(:page_title, "Edit Node")
        |> assign(:node, node)
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create a new SentryPeer Node")
    |> assign(:node, %Node{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "SentryPeer Nodes")
    |> assign(:node, nil)
  end

  @impl true
  def handle_info({SentrypeerWeb.CustomerNodesLive.FormComponent, {:saved, node}}, socket) do
    {:noreply,
     socket
     |> assign(:nodes, list_clients(socket.assigns.current_user.id))
     |> assign(:node, node)}
  end

  @impl true
  def handle_event("delete", %{"client_id" => id}, socket) do
    case delete_node(socket.assigns.current_user.id, id) do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket |> push_event("error", "Node not deleted")}
    end
  end

  defp list_clients(user) do
    case Auth0ManagementAPI.list_clients_by_user(user) do
      {:ok, clients} ->
        clients

      {:error, _} ->
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
