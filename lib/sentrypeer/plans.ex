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

defmodule Sentrypeer.Plans do
  defstruct [
    :tester_plan,
    :free_with_rewarded_ads_plan,
    :contributor_plan,
    :business_small_plan,
    :business_medium_plan,
    :business_large_plan,
    :service_provider_small_plan,
    :service_provider_medium_plan,
    :service_provider_large_plan
  ]

  @moduledoc """
  This module is used to check what plan a user
  """

  def what_plan_am_i_on(user_id) do

  end
end
