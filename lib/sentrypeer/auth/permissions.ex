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

defmodule Sentrypeer.Auth.Permissions do
  @moduledoc """
  List of permissions for our API.
  """

  def read_phone_numbers do
    MapSet.new([read_phone_numbers_perm()])
  end

  def read_ip_addresses do
    MapSet.new([read_ip_addresses_perm()])
  end

  def write_events do
    MapSet.new([write_events_perm()])
  end

  def read_phone_numbers_perm do
    "read:phone-numbers"
  end

  def read_ip_addresses_perm do
    "read:ip-addresses"
  end

  def write_events_perm do
    "write:events"
  end
end
