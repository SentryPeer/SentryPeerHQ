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

defmodule Sentrypeer.Emails.EmailNotification do
  import Swoosh.Email

  def voip_fraud_email_alert(user) do
    new()
    |> to({user.name, user.email})
    |> from({"SentryPeer Alerts", "support@sentrypeer.com"})
    |> subject("SentryPeer has detected potential VoIP fraud")
    |> html_body(
      "<h1>Hi #{user.name},</h1><p>It appears that you have been the victim of a VoIP fraud attack. Please contact your service provider for more information.</p>"
    )
    |> text_body(
      "Hi #{user.name}\nIt appears that you have been the victim of a VoIP fraud attack. Please contact your service provider for more information."
    )
  end
end
