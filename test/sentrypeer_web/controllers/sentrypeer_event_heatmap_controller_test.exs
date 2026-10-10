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

defmodule SentrypeerWeb.SentrypeerEventHeatmapControllerTest do
  use SentrypeerWeb.ConnCase

  alias Sentrypeer.Repo
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  setup %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{current_user: %{id: "user_123", email: "test@example.com"}})
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "GET /api/events/heatmap" do
    test "returns empty list when no events exist in range", %{conn: conn} do
      conn =
        get(conn, ~p"/api/events/heatmap", %{
          "start" => "2026-01-01T00:00:00Z",
          "end" => "2027-01-01T00:00:00Z"
        })

      assert json_response(conn, 200) == []
    end

    test "returns daily counts for events within the range", %{conn: conn} do
      node_id = Ecto.UUID.generate()

      Repo.insert!(%SentrypeerEvent{
        app_name: "test_app",
        app_version: "1.0.0",
        called_number: "12345",
        collected_method: "test",
        created_by_node_id: node_id,
        destination_ip: "127.0.0.1",
        event_timestamp: ~U[2026-05-10 10:00:00.000000Z],
        event_uuid: Ecto.UUID.generate(),
        sip_message: "INVITE",
        sip_method: "INVITE",
        sip_user_agent: "test",
        source_ip: "127.0.0.1",
        transport_type: "UDP",
        client_id: "client_1"
      })

      Repo.insert!(%SentrypeerEvent{
        app_name: "test_app",
        app_version: "1.0.0",
        called_number: "12345",
        collected_method: "test",
        created_by_node_id: node_id,
        destination_ip: "127.0.0.1",
        event_timestamp: ~U[2026-05-10 15:30:00.000000Z],
        event_uuid: Ecto.UUID.generate(),
        sip_message: "INVITE",
        sip_method: "INVITE",
        sip_user_agent: "test",
        source_ip: "127.0.0.1",
        transport_type: "UDP",
        client_id: "client_1"
      })

      Repo.insert!(%SentrypeerEvent{
        app_name: "test_app",
        app_version: "1.0.0",
        called_number: "12345",
        collected_method: "test",
        created_by_node_id: node_id,
        destination_ip: "127.0.0.1",
        event_timestamp: ~U[2026-05-11 08:00:00.000000Z],
        event_uuid: Ecto.UUID.generate(),
        sip_message: "INVITE",
        sip_method: "INVITE",
        sip_user_agent: "test",
        source_ip: "127.0.0.1",
        transport_type: "UDP",
        client_id: "client_1"
      })

      conn =
        get(conn, ~p"/api/events/heatmap", %{
          "start" => "2026-01-01T00:00:00Z",
          "end" => "2027-01-01T00:00:00Z"
        })

      assert json_response(conn, 200) == [
               %{"date" => "2026-05-10", "value" => 2},
               %{"date" => "2026-05-11", "value" => 1}
             ]
    end

    test "redirects unauthenticated users", %{conn: _conn} do
      unauth_conn = build_conn() |> put_req_header("accept", "application/json")

      conn =
        get(unauth_conn, ~p"/api/events/heatmap", %{
          "start" => "2026-01-01T00:00:00Z",
          "end" => "2027-01-01T00:00:00Z"
        })

      assert redirected_to(conn) == "/auth/auth0"
    end
  end
end
