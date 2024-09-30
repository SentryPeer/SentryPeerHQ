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

defmodule Sentrypeer.Emails.EmailError do
  import Swoosh.Email

  @moduledoc """
  The EmailError main message.
  """

  def notify_admins(module, error, user_id) do
    new()
    |> to({"SentryPeerHQ Admins", System.get_env("SENTRYPEER_SUPPORT_EMAIL")})
    |> from({"SentryPeerHQ General Error", "support@sentrypeer.com"})
    |> subject("SentryPeer has seen an error")
    |> html_body(
      "<h1>Error</h1><p>In module <strong>#{module}</strong> experienced by user: <strong>#{user_id}</strong></p><p>#{error}</p>"
    )
    |> text_body("Error:\n\nIn module #{module} experienced by user: #{user_id}\n\n#{error}")
  end
end
