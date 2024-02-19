# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2024 Gavin Henry <ghenry@sentrypeer.org>
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

alias Sentrypeer.Auth.Auth0User
require Logger
alias Sentrypeer.Plans.Plan

defmodule Sentrypeer.Plans do
  @moduledoc """
  This module is used to check what plan a user
  """

  # credo:disable-for-this-file Credo.Check.Design.TagTODO
  def what_plan_am_i_on(user_id) do
    # TODO: Move this to our config or Pg
    plans = [
      %Plan{
        plan_name: :tester_plan,
        rate_limit: 5,
        rate_limit_period: 3600,
        api_clients: 1,
        integrations_analytics: :basic,
        support_level: :community
      },
      %Plan{
        plan_name: :free_with_rewarded_ads_plan,
        rate_limit: 5,
        rate_limit_period: 3600,
        api_clients: 1,
        integrations_analytics: :basic,
        support_level: :community,
        api_credits: :rewarded_ads
      },
      # Move to :proportional for rate_limit ?
      %Plan{
        plan_name: :contributor_plan,
        rate_limit: 3600,
        rate_limit_period: 3600,
        api_clients: 5,
        node_clients: :unlimited,
        integrations_analytics: :basic,
        support_level: :community,
        api_credits: :contributor,
        extra_features: :leaderboard
      },
      %Plan{
        plan_name: :business_small_plan,
        rate_limit: 5,
        rate_limit_period: 60,
        api_clients: 1,
        integrations_analytics: :full,
        support_level: :forty_eight_hours
      },
      %Plan{
        plan_name: :business_medium_plan,
        rate_limit: 25,
        rate_limit_period: 60,
        api_clients: 10,
        integrations_analytics: :full,
        support_level: :twenty_four_hours
      },
      # TODO: Move to :proportional for rate_limit
      %Plan{
        plan_name: :business_large_plan,
        rate_limit: 3600,
        rate_limit_period: 60,
        api_clients: :unlimited,
        integrations_analytics: :full,
        support_level: :twenty_four_hours
      },
      %Plan{
        plan_name: :service_provider_small_plan,
        rate_limit: 5,
        rate_limit_period: 1,
        api_clients: :unlimited,
        integrations_analytics: :full,
        support_level: :four_hours,
        extra_features: :anonymity_api
      },
      %Plan{
        plan_name: :service_provider_medium_plan,
        rate_limit: 25,
        rate_limit_period: 1,
        api_clients: :unlimited,
        integrations_analytics: :full,
        support_level: :four_hours,
        extra_features: :anonymity_api
      },
      # TODO: Move to :proportional for rate_limit
      %Plan{
        plan_name: :service_provider_large_plan,
        rate_limit: 3600,
        rate_limit_period: 60,
        api_clients: :unlimited,
        integrations_analytics: :full,
        support_level: :four_hours,
        extra_features: :anonymity_api
      }
    ]

    auth0_user = %Auth0User{id: user_id}

    Enum.filter(plans, fn plan ->
      FunWithFlags.enabled?(plan.plan_name, for: auth0_user)
    end)
  end
end
