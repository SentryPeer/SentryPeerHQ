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

defmodule Sentrypeer.SentrypeerEventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.SentrypeerEvents` context.
  """

  @doc """
  Generate a unique sentrypeer_event event_uuid.
  """
  def unique_sentrypeer_event_event_uuid do
    raise "implement the logic to generate a unique sentrypeer_event event_uuid"
  end

  @doc """
  Generate a sentrypeer_event.
  """
  def sentrypeer_event_fixture(attrs \\ %{}) do
    {:ok, sentrypeer_event} =
      attrs
      |> Enum.into(%{
        app_name: "some app_name",
        app_version: "some app_version",
        called_number: "some called_number",
        collected_method: "some collected_method",
        created_by_node_id: "7488a646-e31f-11e4-aace-600308960662",
        destination_ip: "some destination_ip",
        event_timestamp: ~N[2023-01-31 17:27:00],
        event_uuid: unique_sentrypeer_event_event_uuid(),
        sip_message: "some sip_message",
        sip_method: "some sip_method",
        sip_user_agent: "some sip_user_agent",
        source_ip: "some source_ip",
        transport_type: "some transport_type"
      })
      |> Sentrypeer.SentrypeerEvents.create_sentrypeer_event()

    sentrypeer_event
  end
end
