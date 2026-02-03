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

defmodule Sentrypeer.ActivityLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.ActivityLogs` context.
  """

  @doc """
  Generate a activity_log.
  """
  def activity_log_fixture(attrs \\ %{}) do
    {:ok, activity_log} =
      attrs
      |> Enum.into(%{
        data: %{},
        event: "some event",
        ip_address: "some ip_address",
        user_agent: "some user_agent"
      })
      |> Sentrypeer.ActivityLogs.create_activity_log()

    activity_log
  end
end
