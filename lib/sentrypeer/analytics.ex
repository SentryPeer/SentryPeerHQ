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

defmodule Sentrypeer.Analytics do
  @moduledoc """
  The Analytics General context.
  """

  import Ecto.Query
  alias Sentrypeer.Repo
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  def base, do: SentrypeerEvent

  def filter_by_interval(query \\ base(), interval) do
    query
    |> apply_interval_filter(interval)
  end

  defp apply_interval_filter(query, "5m") do
    query
    |> where([s], s.event_timestamp > ago(5, "minute"))
  end

  defp apply_interval_filter(query, "15m") do
    query
    |> where([s], s.event_timestamp > ago(15, "minute"))
  end

  defp apply_interval_filter(query, "1h") do
    query
    |> where([s], s.event_timestamp > ago(1, "hour"))
  end

  defp apply_interval_filter(query, "6h") do
    query
    |> where([s], s.event_timestamp > ago(6, "hour"))
  end

  defp apply_interval_filter(query, "12h") do
    query
    |> where([s], s.event_timestamp > ago(12, "hour"))
  end

  defp apply_interval_filter(query, "24h") do
    query
    |> where([s], s.event_timestamp > ago(24, "hour"))
  end

  defp apply_interval_filter(query, "2d") do
    query
    |> where([s], s.event_timestamp > ago(2, "day"))
  end

  defp apply_interval_filter(query, "7d") do
    query
    |> where([s], s.event_timestamp > ago(7, "day"))
  end

  defp apply_interval_filter(query, "30d") do
    query
    |> where([s], s.event_timestamp > ago(30, "day"))
  end

  # Default to 24 hours
  defp apply_interval_filter(query, []) do
    query
    |> where([s], s.event_timestamp > ago(1, "day"))
  end

  def user_agents_highest_top_5(interval) do
    #    query = """
    #    SELECT sip_user_agent, MAX(event_timestamp) AS seen_last,
    #    COUNT(sip_user_agent) AS seen_total
    #    FROM sentrypeerevents
    #    GROUP BY sip_user_agent
    #    ORDER BY seen_total
    #    DESC limit 5;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.sip_user_agent,
        order_by: [desc: count(s.sip_user_agent)],
        limit: 5,
        select: [
          s.sip_user_agent,
          count(s.sip_user_agent)
        ]

    query
    |> filter_by_interval(interval)
    |> Repo.all()
  end

  def countries_of_origination_top_5 do
  end

  def sip_methods_top_5(interval) do
    #    query = """
    #    SELECT sip_method, COUNT(sip_method) AS seen_total
    #    FROM sentrypeerevents
    #    GROUP BY sip_method
    #    ORDER BY seen_total
    #    DESC limit 5;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.sip_method,
        order_by: [desc: count(s.sip_method)],
        limit: 5,
        select: [
          s.sip_method,
          count(s.sip_method)
        ]

    query
    |> filter_by_interval(interval)
    |> Repo.all()
  end

  def events_per_day_total do
    #    query = """
    #    SELECT date_trunc('day', event_timestamp) AS day,
    #    COUNT(event_timestamp) as seen_total
    #    FROM sentrypeerevents
    #    GROUP BY day
    #    ORDER BY day;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: fragment("date_trunc('day', event_timestamp)"),
        order_by: [asc: fragment("date_trunc('day', event_timestamp)")],
        select: [
          "Date",
          fragment("date_trunc('day', event_timestamp)"),
          "Count",
          count(s.event_timestamp)
        ],
        where: s.event_timestamp > ago(30, "day")

    Repo.all(query)
  end
end
