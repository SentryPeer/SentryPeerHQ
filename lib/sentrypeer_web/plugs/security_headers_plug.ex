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

defmodule SentrypeerWeb.Plugs.SecurityHeaders do
  import Plug.Conn

  @moduledoc """
  This plug adds security headers to the response.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    merge_resp_headers(conn, [
      {"server", "undisclosed"},
      {"strict-transport-security", "max-age=31536000; includeSubDomains"},
      {"x-content-type-options", "nosniff"},
      {"x-frame-options", "deny"},
      {"x-xss-protection", "0"}
    ])
  end
end
