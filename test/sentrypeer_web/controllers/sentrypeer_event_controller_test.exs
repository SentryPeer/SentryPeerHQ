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

defmodule SentrypeerWeb.SentrypeerEventControllerTest do
  use SentrypeerWeb.ConnCase

  @create_attrs %{
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

  @not_found %{"errors" => %{"detail" => "Not Found"}}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Returns 401 for POST and 404 for the REST at /api/events" do
    test "returns 401 for POST", %{conn: conn} do
      conn = post(conn, ~p"/api/events")
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "returns 404 for GET", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for PUT", %{conn: conn} do
      conn = put(conn, ~p"/api/events/")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for PATCH", %{conn: conn} do
      conn = patch(conn, ~p"/api/events/")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for DELETE", %{conn: conn} do
      conn = delete(conn, ~p"/api/events/")
      assert json_response(conn, 404) == @not_found
    end
  end

  describe "Returns 401 for GET and 404 for the REST at /api/phone-numbers/23423423" do
    test "returns 401 for GET", %{conn: conn} do
      conn = get(conn, ~p"/api/phone-numbers/23423423")
      assert json_response(conn, 401)["error"] == "missing_token"
    end

    test "returns 404 for POST", %{conn: conn} do
      conn = post(conn, ~p"/api/phone-numbers/23423423")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for PUT", %{conn: conn} do
      conn = put(conn, ~p"/api/phone-numbers/23423423")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for PATCH", %{conn: conn} do
      conn = patch(conn, ~p"/api/phone-numbers/23423423")
      assert json_response(conn, 404) == @not_found
    end

    test "returns 404 for DELETE", %{conn: conn} do
      conn = delete(conn, ~p"/api/phone-numbers/23423423")
      assert json_response(conn, 404) == @not_found
    end
  end

  describe "create sentrypeer_event" do
    test "renders sentrypeer_event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", sentrypeer_event: @create_attrs)
      assert json_response(conn, 201)["data"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", sentrypeer_event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
