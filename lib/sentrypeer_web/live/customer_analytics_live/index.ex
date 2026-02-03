# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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
  alias Contex.{Dataset, PieChart, Plot}
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
       meta_description: "Discover what SentryPeer is seeing in the VoIP fraud world.",
       phone_numbers_top_5_graph: phone_numbers_top_5_graph(),
       phone_numbers_total_unique: phone_numbers_total_unique(),
       source_ips_top_5_graph: source_ips_top_5_graph(),
       source_ips_total_unique: source_ips_total_unique(),
       sip_methods_top_5_graph: sip_methods_top_5_graph(),
       user_agents_highest_top_5_graph: user_agents_highest_top_5_graph(),
       interval: "24h"
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, process_params(socket, params)}
  end

  defp process_params(socket, %{"interval" => interval}) do
    Logger.debug("#{interval} has been selected.")

    socket
    |> recreate_graphs_with_filter(interval)
  end

  defp process_params(socket, %{}) do
    # Do nothing
    socket
  end

  defp recreate_graphs_with_filter(socket, interval) do
    assign(socket,
      phone_numbers_top_5_graph: phone_numbers_top_5_graph(interval),
      phone_numbers_total_unique: phone_numbers_total_unique(interval),
      source_ips_top_5_graph: source_ips_top_5_graph(interval),
      source_ips_total_unique: source_ips_total_unique(interval),
      sip_methods_top_5_graph: sip_methods_top_5_graph(interval),
      user_agents_highest_top_5_graph: user_agents_highest_top_5_graph(interval),
      interval: interval
    )
  end

  defp phone_numbers_top_5_graph(interval \\ []) do
    opts = [
      mapping: %{category_col: "Phone Number", value_col: "Count"},
      legend_setting: :legend_top,
      data_labels: true,
      title: "Top 5 Phone Numbers"
    ]

    Analytics.PhoneNumbers.top_5(interval)
    |> Dataset.new(["Phone Number", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end

  defp phone_numbers_total_unique(interval \\ []) do
    Analytics.PhoneNumbers.total_unique(interval)
  end

  defp source_ips_top_5_graph(interval \\ []) do
    opts = [
      mapping: %{category_col: "IP Address", value_col: "Count"},
      legend_setting: :legend_top,
      data_labels: true,
      title: "Top 5 IP Addresses"
    ]

    Analytics.SourceIPS.top_5(interval)
    |> Dataset.new(["IP Address", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end

  defp source_ips_total_unique(interval \\ []) do
    Analytics.SourceIPS.total_unique(interval)
  end

  defp sip_methods_top_5_graph(interval \\ []) do
    opts = [
      mapping: %{category_col: "SIP Method", value_col: "Count"},
      legend_setting: :legend_top,
      data_labels: true,
      title: "Top 5 SIP Methods"
    ]

    Analytics.sip_methods_top_5(interval)
    |> Dataset.new(["SIP Method", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end

  defp user_agents_highest_top_5_graph(interval \\ []) do
    opts = [
      mapping: %{category_col: "User Agent", value_col: "Count"},
      legend_setting: :legend_top,
      data_labels: true,
      title: "Top 5 SIP User Agents"
    ]

    Analytics.user_agents_highest_top_5(interval)
    |> Dataset.new(["User Agent", "Count"])
    |> Plot.new(PieChart, 600, 400, opts)
    |> Plot.to_svg()
  end
end
