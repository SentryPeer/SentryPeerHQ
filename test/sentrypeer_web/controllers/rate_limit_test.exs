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

defmodule SentrypeerWeb.API.RateLimitPlugTest do
  use SentrypeerWeb.ConnCase, async: true

  alias SentrypeerWeb.RateLimitPlug

  @path "/"
  @rate_limit_options [max_requests: 1, interval_seconds: 60]

  setup do
    bucket_name = "127.0.0.1:" <> @path

    on_exit(fn ->
      ExRated.delete_bucket(bucket_name)
    end)
  end

  describe "rate_limit" do
    test "429 Too Many Requests when beyond limit", %{conn: _conn} do
      conn1 =
        build_conn()
        |> bypass_through(SentrypeerWeb.Router, :api)
        |> get(@path)
        |> RateLimitPlug.rate_limit(@rate_limit_options)

      refute conn1.halted

      conn2 =
        build_conn()
        |> bypass_through(SentrypeerWeb.Router, :api)
        |> get(@path)
        |> RateLimitPlug.rate_limit(@rate_limit_options)

      assert conn2.halted
      assert json_response(conn2, 429) == %{"status" => "429 Too Many Requests"}
    end
  end
end
