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

defmodule Sentrypeer.BillingHelpers do
  @moduledoc """
  Billing Helpers.

  ## Examples

      iex> Sentrypeer.BillingHelpers.get_next_month(12)
      1

  """

  def first_of_next_month_unix do
    today = Date.utc_today()

    NaiveDateTime.from_erl!({{today.year, get_next_month(today.month), 1}, {0, 0, 0}})
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_unix()
  end

  def get_next_month(current_month) do
    case current_month do
      # Dec becomes Jan
      12 -> 1
      _ -> current_month + 1
    end
  end

  def to_month_day(unixtime) do
    Timex.from_unix(unixtime, :seconds)
    |> Timex.format!("{Mshort} {D}")
  end

  def to_year(unixtime) do
    Timex.from_unix(unixtime, :seconds)
    |> Timex.format!("{YYYY}")
  end
end
