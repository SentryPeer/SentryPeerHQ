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

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug(inspect(session["current_user"].id))

    data = [["Apples", 10], ["Bananas", 12], ["Pears", 2]]

    output =
      data
      |> Contex.Dataset.new()
      |> Contex.Plot.new(Contex.BarChart, 600, 400)
      |> Contex.Plot.to_svg()

    {:ok,
     assign(socket,
       current_user: session["current_user"],
       app_version: Application.spec(:sentrypeer, :vsn),
       git_rev: Application.get_env(:sentrypeer, :git_rev),
       page_title: "Analytics" <> " · SentryPeer",
       graph: output
     )}
  end
end
