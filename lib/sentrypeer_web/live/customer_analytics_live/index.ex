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
  alias Contex.{Dataset, BarChart, PieChart, Plot}
  alias Sentrypeer.Analytics

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Analytics" <> " · SentryPeer",
       sip_methods_top_10_graph: sip_methods_top_10_graph(),
       user_agents_highest_top_10_graph: user_agents_highest_top_10_graph()
     )}
  end

  defp sip_methods_top_10_graph do
    opts = [
      mapping: %{category_col: "SIP Method", value_col: "Count"},
      legend_setting: :legend_right,
      data_labels: true,
      title: "Top 10 SIP Methods"
    ]

    Analytics.sip_methods_top_10()
    |> Dataset.new(["SIP Method", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end

  defp user_agents_highest_top_10_graph do
    opts = [
      mapping: %{category_col: "User Agent", value_col: "Count"},
      legend_setting: :legend_right,
      data_labels: true,
      title: "Top 10 SIP User Agents"
    ]

    Analytics.user_agents_highest_top_10()
    |> Dataset.new(["User Agent", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end
end
