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

defmodule Sentrypeer.Emails.EmailContactForm do
  import Swoosh.Email

  @moduledoc """
  The EmailContactForm main message.
  """

  def notify_sales(contact) do
    new()
    |> to({"SentryPeerHQ Sales Team", System.get_env("SENTRYPEER_SUPPORT_EMAIL")})
    |> from({"SentryPeerHQ Sales Contact From", "sales@sentrypeer.com"})
    |> subject("SentryPeerHQ has an enquiry")
    |> html_body("<h1>Message</h1><p>#{inspect(contact)}</p>")
    |> text_body("Message:\n\n#{inspect(contact)}")
  end
end
