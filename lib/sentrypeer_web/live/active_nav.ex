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

# Taken from https://fly.io/phoenix-files/liveview-active-nav/

# credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity
defmodule SentrypeerWeb.ActiveNav do
  use SentrypeerWeb, :live_view
  require Logger

  @moduledoc """
  This module is used to set the active page based on the current live view loaded.
  """

  def render(assigns) do
    ~H"""

    """
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:active_page, :handle_params, &set_active_page/3)}
  end

  defp set_active_page(_params, _url, socket) do
    active_page =
      case {socket.view, socket.assigns.live_action} do
        {SentrypeerWeb.HomeLive.Index, _} ->
          :home_page

        {SentrypeerWeb.CustomerDashboardLive.Index, _} ->
          :dashboard

        {SentrypeerWeb.CustomerAnalyticsLive.Index, _} ->
          :analytics

        {SentrypeerWeb.CustomerInsightsLive.Index, _} ->
          :insights

        {SentrypeerWeb.CustomerNodesLive.Index, _} ->
          :nodes

        {SentrypeerWeb.CustomerNodesLive.Overview, _} ->
          :node_overview

        {SentrypeerWeb.CustomerBillingLive.Index, _} ->
          :billing

        {SentrypeerWeb.CustomerTeamLive.Index, _} ->
          :team

        {SentrypeerWeb.CustomerIntegrationsLive.Index, _} ->
          :integrations

        {SentrypeerWeb.CustomerSettingsLive.Index, _} ->
          :settings

        {SentrypeerWeb.CustomerSettingsLive.Overview, _} ->
          :settings_overview

        {SentrypeerWeb.UserProfileLive.Index, _} ->
          :user_profile

        {SentrypeerWeb.UserSettingsLive.Index, _} ->
          :user_settings

        {_, _} ->
          nil
      end

    Logger.debug("Active page: #{inspect(active_page)}")

    {:cont, assign(socket, active_page: active_page)}
  end
end
