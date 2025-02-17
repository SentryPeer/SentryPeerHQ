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

defmodule Sentrypeer.Plans.Plan do
  @moduledoc """
  The main plan struct.
  """

  defstruct plan_name: :tester_plan,
            rate_limit: 5,
            rate_limit_period: 3600,
            api_clients: 1,
            node_clients: 1,
            integrations_analytics: :basic,
            support_level: :community,
            api_credits: :none,
            extra_features: :none

  @type t :: %__MODULE__{
          plan_name: atom(),
          rate_limit: integer(),
          rate_limit_period: integer(),
          api_clients: integer(),
          node_clients: integer(),
          integrations_analytics: :basic | :full,
          support_level: :community | :forty_eight_hours | :twenty_four_hours | :four_hours,
          api_credits: :rewarded_ads | :contributor | :none,
          extra_features: :leaderboard | :anonymity_api | :none
        }
end
