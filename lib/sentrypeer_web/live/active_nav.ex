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
defmodule SentrypeerWeb.ActiveNav do
  use SentrypeerWeb, :live_view
  require Logger

  def render(assigns) do
    ~H"""

    """
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:active_tab, :handle_params, &set_active_tab/3)}
  end

  defp set_active_tab(params, _url, socket) do
    active_tab =
      case {socket.view, socket.assigns.live_action} do
        {SentrypeerWeb.CustomerDashboardLive.Index, _} ->
          :dashboard

        {SentrypeerWeb.CustomerNodesLive.Index, _} ->
          :nodes

        {SentrypeerWeb.CustomerNodesLive.Overview, _} ->
          :node_overview

        {_, _} ->
          nil
      end

    Logger.debug("Active tab: #{inspect(active_tab)}")

    {:cont, assign(socket, active_tab: active_tab)}
  end

  defp current_user(socket) do
    socket.assigns.current_user.id
  end
end
