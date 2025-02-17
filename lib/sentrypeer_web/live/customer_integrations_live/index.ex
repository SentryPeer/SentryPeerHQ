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

defmodule SentrypeerWeb.CustomerIntegrationsLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents

  alias Sentrypeer.Accounts
  alias Sentrypeer.Alerts
  alias Sentrypeer.Emails.EmailIntegrationConfirm
  alias Sentrypeer.Integrations.Integration
  alias Sentrypeer.Token

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    integrations =
      Accounts.get_user_by_auth_id_with_integrations(session["current_user"].id).integrations

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Integrations" <> " · SentryPeer",
       meta_description: "SentryPeer Integrations directory",
       integrations: integrations,
       email_integration_exists: get_email_integration(integrations),
       slack_integration_exists: get_slack_integration(integrations),
       webhook_integration_exists: get_webhook_integration(integrations),
       test_message_sent: false
     )}
  end

  @impl true
  def handle_params(params, _destination, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:integration, nil)
  end

  defp apply_action(socket, :email_edit, _params) do
    socket
    |> assign(:page_title, "Edit Email Integration")
    |> assign(:page_subtitle, "Email alerts use the following details.")
    |> assign(:integration_type, "email")
    |> assign(
      :integration,
      get_email_integration(
        Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id).integrations
      )
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
    |> assign(:page_subtitle, "Slack alerts will use the following details.")
    |> assign(:integration_type, "slack")
    |> assign(
      :integration,
      get_slack_integration(
        Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id).integrations
      )
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
    |> assign(:page_subtitle, "Webhook alerts will use the following details.")
    |> assign(:integration_type, "webhook")
    |> assign(
      :integration,
      get_webhook_integration(
        Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id).integrations
      )
    )
  end

  defp apply_action(socket, :webhook_new, _params) do
    socket
    |> assign(:page_title, "New Webhook Integration · SentryPeer")
    |> assign(:page_subtitle, "Webhook alerts will use the following details.")
    |> assign(:integration_type, "webhook")
    |> assign(:integration, %Integration{})
  end

  defp get_email_integration(integrations) do
    Enum.find(integrations, fn i -> i.type == "email" end)
  end

  defp get_slack_integration(integrations) do
    Enum.find(integrations, fn i -> i.type == "slack" end)
  end

  defp get_webhook_integration(integrations) do
    Enum.find(integrations, fn i -> i.type == "webhook" end)
  end

  @impl true
  def handle_event("test", %{"value" => "email"}, socket) do
    Logger.debug("Send test email to #{socket.assigns.integration.destination}")

    if socket.assigns.integration.verified == false do
      EmailIntegrationConfirm.send!(
        socket.assigns.integration,
        Token.generate_token(socket.assigns.integration.id)
      )
    end

    Alerts.Email.send_alert(
      socket.assigns.integration,
      "Testing SentryPeer Email Integration"
    )

    {:noreply,
     socket
     |> assign(:test_message_sent, true)}
  end

  @impl true
  def handle_event("test", %{"value" => "slack"}, socket) do
    Logger.debug("Send test slack webhook to #{socket.assigns.integration.destination}")

    Alerts.Slack.send_alert(
      socket.assigns.integration,
      "Testing SentryPeer Slack Integration"
    )

    {:noreply,
     socket
     |> assign(:test_message_sent, true)}
  end

  @impl true
  def handle_event("test", %{"value" => "webhook"}, socket) do
    Logger.debug("Send test webhook to #{socket.assigns.integration.destination}")

    Alerts.Webhook.send_alert(
      socket.assigns.integration,
      "Testing SentryPeer Webhook Integration"
    )

    {:noreply,
     socket
     |> assign(:test_message_sent, true)}
  end

  @impl true
  def handle_info(
        {SentrypeerWeb.CustomerIntegrationsLive.FormComponent, {:saved, _integration}},
        socket
      ) do
    integrations =
      Accounts.get_user_by_auth_id_with_integrations(socket.assigns.current_user.id).integrations

    {:noreply,
     assign(socket,
       page_title: "Integrations" <> " · SentryPeer",
       integrations: integrations,
       email_integration_exists: get_email_integration(integrations),
       slack_integration_exists: get_slack_integration(integrations),
       webhook_integration_exists: get_webhook_integration(integrations),
       test_message_sent: false
     )}
  end
end
