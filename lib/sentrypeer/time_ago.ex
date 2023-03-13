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

defmodule Sentrypeer.TimeAgo do
  @moduledoc """
  This module is used to generate a human readable time ago string. It 
  uses the Cldr.DateTime.Relative.to_string function to generate the
  string. 
  """

  def time_ago(nil) do
    "today?"
  end

  def time_ago(datetime) do
    case DateTime.from_iso8601(datetime) do
      {:ok, datetime, _} ->
        {:ok, time_ago_string} = Cldr.DateTime.Relative.to_string(datetime, Sentrypeer.Cldr)
        time_ago_string

      nil ->
        time_ago(nil)
    end
  end
end
