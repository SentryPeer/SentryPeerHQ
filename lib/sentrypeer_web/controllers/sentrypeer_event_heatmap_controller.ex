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

defmodule SentrypeerWeb.SentrypeerEventHeatmapController do
  use SentrypeerWeb, :controller

  alias Sentrypeer.SentrypeerEvents

  require Logger

  def heatmap(conn, %{"start" => start_date, "end" => end_date}) do
    {:ok, start_date_filter, 0} = DateTime.from_iso8601(start_date)
    {:ok, end_date_filter, 0} = DateTime.from_iso8601(end_date)

    Logger.debug("start_date: #{inspect(start_date_filter)}")
    Logger.debug("end_date: #{inspect(end_date_filter)}")

    events_for_heatmap =
      SentrypeerEvents.total_events_per_day!(start_date_filter, end_date_filter)

    Logger.debug("events_for_heatmap: #{inspect(events_for_heatmap)}")

    events_in_short_date_format =
      Enum.map(events_for_heatmap, fn %{date: date, value: count} ->
        %{date: String.slice(to_string(date), 0, 10), value: count}
      end)

    Logger.debug("events_in_short_date_format: #{inspect(events_in_short_date_format)}")

    conn
    |> put_status(:ok)
    |> json(events_in_short_date_format)
  end
end
