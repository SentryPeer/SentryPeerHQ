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

defmodule SentrypeerWeb.CustomerDashboardLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents
  alias Sentrypeer.SentrypeerEvents

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: SentrypeerEvents.subscribe_all_nodes()

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Dashboard" <> " · SentryPeer",
       total_events: total_events()
     )}
  end

  defp total_events() do
    Sentrypeer.SentrypeerEvents.total_events!()
  end

  @impl true
  def handle_info({:ok}, socket) do
    {:noreply,
     assign(socket,
       total_events: total_events()
     )}
  end
end
