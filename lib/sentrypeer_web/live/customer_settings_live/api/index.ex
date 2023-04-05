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

defmodule SentrypeerWeb.CustomerSettingsLive.Api.Index do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.CustomerClients.Client

  import Sentrypeer.TimeAgo
  import SentrypeerWeb.NavigationComponents

  @impl true
  def mount(_params, session, socket) do
    clients = list_clients(session["current_user"].id)

    {:ok,
     assign(socket,
       # .avatar is in there too
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Clients",
       clients: clients
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"client_id" => id}) do
    case Auth0ManagementAPI.get_client_for_user(socket.assigns.current_user.id, id) do
      nil ->
        socket |> assign(:page_title, "Client not found")

      {:ok, client} ->
        socket
        |> assign(:page_title, "Edit Client")
        |> assign(:client, client)
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create a new SentryPeer API client")
    |> assign(:client, %Client{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "SentryPeer API clients")
    |> assign(:client, nil)
  end

  @impl true
  def handle_info({SentrypeerWeb.CustomerClientsLive.FormComponent, {:saved, client}}, socket) do
    {:noreply,
     socket
     |> assign(:clients, list_clients(socket.assigns.current_user.id))
     |> assign(:client, client)}
  end

  @impl true
  def handle_event("delete", %{"client_id" => id}, socket) do
    case delete_client(socket.assigns.current_user.id, id) do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket |> push_event("error", "Client not deleted")}
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

  defp delete_client(user, id) do
    case Auth0ManagementAPI.delete_client_for_user(user, id) do
      {:ok, _} ->
        {:ok, "Client deleted"}

      {:error, _} ->
        {:error, "Client not deleted"}
    end
  end
end
