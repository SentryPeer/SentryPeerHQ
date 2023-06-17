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

defmodule Sentrypeer.Analytics.PhoneNumbers do
  @moduledoc """
  The Analytics Phone Numbers context.
  """

  alias Sentrypeer.Repo

  def most_recent_attempted_top_10 do
    query = """
    SELECT called_number, MAX(event_timestamp) AS seen_last,
    COUNT(called_number) as seen_total
    FROM sentrypeerevents
    GROUP BY called_number
    ORDER BY MAX(event_timestamp)
    DESC limit 10;
    """

    Repo.query!(query)
  end

  def highest_attempted_top_10 do
    query = """
    SELECT called_number, MAX(event_timestamp) AS seen_last,
    COUNT(called_number) as seen_total
    FROM sentrypeerevents
    GROUP BY called_number
    ORDER BY seen_total
    DESC limit 10;
    """

    Repo.query!(query)
  end

  def total_unique do
    query = """
    SELECT COUNT(DISTINCT called_number) AS seen_total
    FROM sentrypeerevents;
    """

    Repo.query!(query)
  end
end
