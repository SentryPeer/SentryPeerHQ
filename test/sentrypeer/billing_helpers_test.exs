# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.BillingHelpersTest do
  use ExUnit.Case
  doctest Sentrypeer.BillingHelpers

  alias Sentrypeer.BillingHelpers

  test "check month returned" do
    assert BillingHelpers.get_next_month(1) == 2
    assert BillingHelpers.get_next_month(2) == 3
    assert BillingHelpers.get_next_month(3) == 4
    assert BillingHelpers.get_next_month(4) == 5
    assert BillingHelpers.get_next_month(5) == 6
    assert BillingHelpers.get_next_month(6) == 7
    assert BillingHelpers.get_next_month(7) == 8
    assert BillingHelpers.get_next_month(8) == 9
    assert BillingHelpers.get_next_month(9) == 10
    assert BillingHelpers.get_next_month(10) == 11
    assert BillingHelpers.get_next_month(11) == 12
    assert BillingHelpers.get_next_month(12) == 1
  end
end
