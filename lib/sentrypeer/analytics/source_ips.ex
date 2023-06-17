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

defmodule Sentrypeer.Analytics.SourceIPS do
  @moduledoc """
  The Analytics context.
  """

  alias Sentrypeer.Repo

  def most_recent_hits_top_10 do
    query = """
    SELECT source_ip, MAX(event_timestamp) AS seen_last,
    COUNT(source_ip) as seen_total
    FROM sentrypeerevents
    GROUP BY source_ip
    ORDER BY max(event_timestamp)
    DESC limit 10;
    """

    Repo.query!(query)
  end

  def highest_top_10 do
    query = """
    SELECT source_ip, MAX(event_timestamp) AS seen_last,
    COUNT(source_ip) as seen_total
    FROM sentrypeerevents
    GROUP BY source_ip
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
