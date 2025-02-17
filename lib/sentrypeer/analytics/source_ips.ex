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

defmodule Sentrypeer.Analytics.SourceIPS do
  @moduledoc """
  The Analytics context.
  """

  import Ecto.Query
  alias Sentrypeer.Analytics
  alias Sentrypeer.Repo
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  def most_recent_hits_top_5(interval) do
    #    query = """
    #    SELECT source_ip, MAX(event_timestamp) AS seen_last,
    #    COUNT(source_ip) as seen_total
    #    FROM sentrypeerevents
    #    GROUP BY source_ip
    #    ORDER BY max(event_timestamp)
    #    DESC limit 5;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.source_ip,
        order_by: [desc: max(s.event_timestamp)],
        limit: 5,
        select: %{
          source_ip: s.source_ip,
          seen_last: max(s.event_timestamp),
          seen_total: count(s.source_ip)
        }

    query
    |> Analytics.filter_by_interval(interval)
    |> Repo.all()
  end

  def highest_top_5(interval) do
    #    query = """
    #    SELECT source_ip, MAX(event_timestamp) AS seen_last,
    #    COUNT(source_ip) as seen_total
    #    FROM sentrypeerevents
    #    GROUP BY source_ip
    #    ORDER BY seen_total
    #    DESC limit 5;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.source_ip,
        order_by: [desc: count(s.source_ip)],
        limit: 5,
        select: %{
          source_ip: s.source_ip,
          seen_last: max(s.event_timestamp),
          seen_total: count(s.source_ip)
        }

    query
    |> Analytics.filter_by_interval(interval)
    |> Repo.all()
  end

  def top_5(interval) do
    query =
      from s in SentrypeerEvent,
        group_by: s.source_ip,
        order_by: [desc: count(s.source_ip)],
        limit: 5,
        select: [
          s.source_ip,
          count(s.source_ip)
        ]

    query
    |> Analytics.filter_by_interval(interval)
    |> Repo.all()
  end

  def total_unique(interval) do
    #    query = """
    #    SELECT COUNT(DISTINCT source_ip) AS seen_total
    #    FROM sentrypeerevents;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        distinct: s.source_ip

    query
    |> Analytics.filter_by_interval(interval)
    |> Repo.aggregate(:count, :source_ip)
  end
end
