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

defmodule SentrypeerWeb.CustomerIntegrationsLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents

  alias Sentrypeer.Accounts
  alias Sentrypeer.Integrations
  alias Sentrypeer.Integrations.Integration

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Integrations" <> " · SentryPeer"
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:integration, nil)
  end

  defp apply_action(socket, :email_edit) do
    socket
    |> assign(:page_title, "Edit Integration")
    |> assign(
      :integration,
      Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id)
    )
  end

  defp apply_action(socket, :email_new, _params) do
    socket
    |> assign(:page_title, "New Email Integration · SentryPeer")
    |> assign(:page_subtitle, "Email alerts will use the following details.")
    |> assign(:integration_type, "email")
    |> assign(:integration, %Integration{})
  end

  defp apply_action(socket, :slack_edit, _params) do
    socket
    |> assign(:page_title, "Edit Slack Integration · SentryPeer")
    |> assign(
      :integration,
      Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id)
    )
  end

  defp apply_action(socket, :slack_new, _params) do
    socket
    |> assign(:page_title, "New Slack Integration · SentryPeer")
    |> assign(:page_subtitle, "Slack alerts will use the following details.")
    |> assign(:integration_type, "slack")
    |> assign(:integration, %Integration{})
  end

  defp apply_action(socket, :webhook_edit, _params) do
    socket
    |> assign(:page_title, "Edit Webhook Integration · SentryPeer")
    |> assign(
      :integration,
      Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id)
    )
  end

  defp apply_action(socket, :webhook_new, _params) do
    socket
    |> assign(:page_title, "New Webhook Integration · SentryPeer")
    |> assign(:page_subtitle, "Webhook alerts will use the following details.")
    |> assign(:integration_type, "webhook")
    |> assign(:integration, %Integration{})
  end

  @impl true
  def handle_info(
        {SentrypeerWeb.CustomerIntegrationsLive.FormComponent, {:saved, integration}},
        socket
      ) do
    {:noreply, socket}
  end
end
