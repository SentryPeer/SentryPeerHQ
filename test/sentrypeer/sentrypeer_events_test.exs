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

defmodule Sentrypeer.SentrypeerEventsTest do
  use Sentrypeer.DataCase

  alias Sentrypeer.SentrypeerEvents

  describe "sentrypeerevents" do
    alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

    import Sentrypeer.SentrypeerEventsFixtures

    @invalid_attrs %{
      app_name: nil,
      app_version: nil,
      called_number: nil,
      collected_method: nil,
      created_by_node_id: nil,
      destination_ip: nil,
      event_timestamp: nil,
      event_uuid: nil,
      sip_message: nil,
      sip_method: nil,
      sip_user_agent: nil,
      source_ip: nil,
      transport_type: nil
    }

    test "list_sentrypeerevents/0 returns all sentrypeerevents" do
      sentrypeer_event = sentrypeer_event_fixture()
      assert SentrypeerEvents.list_sentrypeerevents() == [sentrypeer_event]
    end

    test "get_sentrypeer_event!/1 returns the sentrypeer_event with given id" do
      sentrypeer_event = sentrypeer_event_fixture()
      assert SentrypeerEvents.get_sentrypeer_event!(sentrypeer_event.id) == sentrypeer_event
    end

    test "create_sentrypeer_event/1 with valid data creates a sentrypeer_event" do
      valid_attrs = %{
        app_name: "some app_name",
        app_version: "some app_version",
        called_number: "some called_number",
        collected_method: "some collected_method",
        created_by_node_id: "7488a646-e31f-11e4-aace-600308960662",
        destination_ip: "some destination_ip",
        event_timestamp: ~N[2023-01-31 17:27:00],
        event_uuid: "7488a646-e31f-11e4-aace-600308960662",
        sip_message: "some sip_message",
        sip_method: "some sip_method",
        sip_user_agent: "some sip_user_agent",
        source_ip: "some source_ip",
        transport_type: "some transport_type"
      }

      assert {:ok, %SentrypeerEvent{} = sentrypeer_event} =
               SentrypeerEvents.create_sentrypeer_event(valid_attrs)

      assert sentrypeer_event.app_name == "some app_name"
      assert sentrypeer_event.app_version == "some app_version"
      assert sentrypeer_event.called_number == "some called_number"
      assert sentrypeer_event.collected_method == "some collected_method"
      assert sentrypeer_event.created_by_node_id == "7488a646-e31f-11e4-aace-600308960662"
      assert sentrypeer_event.destination_ip == "some destination_ip"
      assert sentrypeer_event.event_timestamp == ~N[2023-01-31 17:27:00]
      assert sentrypeer_event.event_uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert sentrypeer_event.sip_message == "some sip_message"
      assert sentrypeer_event.sip_method == "some sip_method"
      assert sentrypeer_event.sip_user_agent == "some sip_user_agent"
      assert sentrypeer_event.source_ip == "some source_ip"
      assert sentrypeer_event.transport_type == "some transport_type"
    end

    test "create_sentrypeer_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               SentrypeerEvents.create_sentrypeer_event(@invalid_attrs)
    end

    test "update_sentrypeer_event/2 with valid data updates the sentrypeer_event" do
      sentrypeer_event = sentrypeer_event_fixture()

      update_attrs = %{
        app_name: "some updated app_name",
        app_version: "some updated app_version",
        called_number: "some updated called_number",
        collected_method: "some updated collected_method",
        created_by_node_id: "7488a646-e31f-11e4-aace-600308960668",
        destination_ip: "some updated destination_ip",
        event_timestamp: ~N[2023-02-01 17:27:00],
        event_uuid: "7488a646-e31f-11e4-aace-600308960668",
        sip_message: "some updated sip_message",
        sip_method: "some updated sip_method",
        sip_user_agent: "some updated sip_user_agent",
        source_ip: "some updated source_ip",
        transport_type: "some updated transport_type"
      }

      assert {:ok, %SentrypeerEvent{} = sentrypeer_event} =
               SentrypeerEvents.update_sentrypeer_event(sentrypeer_event, update_attrs)

      assert sentrypeer_event.app_name == "some updated app_name"
      assert sentrypeer_event.app_version == "some updated app_version"
      assert sentrypeer_event.called_number == "some updated called_number"
      assert sentrypeer_event.collected_method == "some updated collected_method"
      assert sentrypeer_event.created_by_node_id == "7488a646-e31f-11e4-aace-600308960668"
      assert sentrypeer_event.destination_ip == "some updated destination_ip"
      assert sentrypeer_event.event_timestamp == ~N[2023-02-01 17:27:00]
      assert sentrypeer_event.event_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert sentrypeer_event.sip_message == "some updated sip_message"
      assert sentrypeer_event.sip_method == "some updated sip_method"
      assert sentrypeer_event.sip_user_agent == "some updated sip_user_agent"
      assert sentrypeer_event.source_ip == "some updated source_ip"
      assert sentrypeer_event.transport_type == "some updated transport_type"
    end

    test "update_sentrypeer_event/2 with invalid data returns error changeset" do
      sentrypeer_event = sentrypeer_event_fixture()

      assert {:error, %Ecto.Changeset{}} =
               SentrypeerEvents.update_sentrypeer_event(sentrypeer_event, @invalid_attrs)

      assert sentrypeer_event == SentrypeerEvents.get_sentrypeer_event!(sentrypeer_event.id)
    end

    test "delete_sentrypeer_event/1 deletes the sentrypeer_event" do
      sentrypeer_event = sentrypeer_event_fixture()

      assert {:ok, %SentrypeerEvent{}} =
               SentrypeerEvents.delete_sentrypeer_event(sentrypeer_event)

      assert_raise Ecto.NoResultsError, fn ->
        SentrypeerEvents.get_sentrypeer_event!(sentrypeer_event.id)
      end
    end

    test "change_sentrypeer_event/1 returns a sentrypeer_event changeset" do
      sentrypeer_event = sentrypeer_event_fixture()
      assert %Ecto.Changeset{} = SentrypeerEvents.change_sentrypeer_event(sentrypeer_event)
    end
  end
end
