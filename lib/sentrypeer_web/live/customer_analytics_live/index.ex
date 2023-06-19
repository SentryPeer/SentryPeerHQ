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

defmodule SentrypeerWeb.CustomerAnalyticsLive.Index do
  use SentrypeerWeb, :live_view

  import SentrypeerWeb.NavigationComponents
  alias Contex
  alias Sentrypeer.Analytics

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    sip_methods_top_10_opts = [
      mapping: %{category_col: "SIP Method", value_col: "Count"},
      legend_setting: :legend_right,
      data_labels: true,
      title: "Top 10 SIP Methods"
    ]

    sip_methods_top_10_output =
      Analytics.sip_methods_top_10()
      |> Contex.Dataset.new(["SIP Method", "Count"])
      |> Contex.Plot.new(Contex.PieChart, 600, 400, sip_methods_top_10_opts)
      |> Contex.Plot.to_svg()

    user_agents_highest_top_10_opts = [
      mapping: %{category_col: "User Agent", value_col: "Count"},
      legend_setting: :legend_right,
      data_labels: true,
      title: "Top 10 SIP User Agents"
    ]

    user_agents_highest_top_10_output =
      Analytics.user_agents_highest_top_10()
      |> Contex.Dataset.new(["User Agent", "Count"])
      |> Contex.Plot.new(Contex.PieChart, 600, 400, user_agents_highest_top_10_opts)
      |> Contex.Plot.to_svg()

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Analytics" <> " · SentryPeer",
       sip_methods_top_10_graph: sip_methods_top_10_output,
       user_agents_highest_top_10_graph: user_agents_highest_top_10_output
     )}
  end
end
