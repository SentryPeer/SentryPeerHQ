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

defmodule Sentrypeer.Analytics do
  @moduledoc """
  The Analytics General context.
  """

  import Ecto.Query
  alias Sentrypeer.Repo
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  def user_agents_highest_top_10 do
    #    query = """
    #    SELECT sip_user_agent, MAX(event_timestamp) AS seen_last,
    #    COUNT(sip_user_agent) AS seen_total
    #    FROM sentrypeerevents
    #    GROUP BY sip_user_agent
    #    ORDER BY seen_total
    #    DESC limit 10;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.sip_user_agent,
        order_by: [desc: count(s.sip_user_agent)],
        limit: 10,
        select: [
          s.sip_user_agent,
          count(s.sip_user_agent)
        ]

    Repo.all(query)
  end

  def countries_of_origination_top_10 do
  end

  def sip_methods_top_10 do
    #    query = """
    #    SELECT sip_method, COUNT(sip_method) AS seen_total
    #    FROM sentrypeerevents
    #    GROUP BY sip_method
    #    ORDER BY seen_total
    #    DESC limit 10;
    #    """
    #
    #    Repo.query!(query)

    query =
      from s in SentrypeerEvent,
        group_by: s.sip_method,
        order_by: [desc: count(s.sip_method)],
        limit: 10,
        select: [
          s.sip_method,
          count(s.sip_method)
        ]

    Repo.all(query)
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
        select: %{
          day: fragment("date_trunc('day', event_timestamp)"),
          seen_total: count(s.event_timestamp)
        }

    Repo.all(query)
  end
end
