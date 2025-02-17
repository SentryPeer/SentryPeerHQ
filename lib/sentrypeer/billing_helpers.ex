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

defmodule Sentrypeer.BillingHelpers do
  @moduledoc """
  Billing Helpers.

  ## Examples

      iex> Sentrypeer.BillingHelpers.get_next_month(12)
      1

  """

  def tester_plan_id do
    System.get_env("STRIPE_TESTER_PLAN_ID")
  end

  def rewarded_ad_plan_id do
    System.get_env("STRIPE_REWARDED_AD_PLAN_ID")
  end

  def contributor_plan_id do
    System.get_env("STRIPE_CONTRIBUTOR_PLAN_ID")
  end

  def business_small_plan_id do
    System.get_env("STRIPE_BUSINESS_SMALL_PLAN_ID")
  end

  def business_medium_plan_id do
    System.get_env("STRIPE_BUSINESS_MEDIUM_PLAN_ID")
  end

  def business_large_plan_id do
    System.get_env("STRIPE_BUSINESS_LARGE_PLAN_ID")
  end

  def service_provider_small_plan_id do
    System.get_env("STRIPE_SERVICE_PROVIDER_SMALL_PLAN_ID")
  end

  def service_provider_medium_plan_id do
    System.get_env("STRIPE_SERVICE_PROVIDER_MEDIUM_PLAN_ID")
  end

  def service_provider_large_plan_id do
    System.get_env("STRIPE_SERVICE_PROVIDER_LARGE_PLAN_ID")
  end

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

  def unix_to_naive_datetime(nil), do: nil

  def unix_to_naive_datetime(datetime_in_seconds) do
    datetime_in_seconds
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end

  def lowercase_spaces_to_underscores(string) do
    string
    |> String.downcase()
    |> String.replace(" ", "_")
  end
end
