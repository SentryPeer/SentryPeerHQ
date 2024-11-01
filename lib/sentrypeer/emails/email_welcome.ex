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

defmodule Sentrypeer.Emails.EmailWelcome do
  use Phoenix.Swoosh,
    view: Sentrypeer.Emails,
    layout: {Sentrypeer.Emails, "layout.html"}

  alias Sentrypeer.Mailer

  @moduledoc """
  The EmailWelcome main messages.
  """

  def welcome(user) do
    new()
    |> subject("Welcome to SentryPeer!")
    |> to(user.email)
    |> from({"SentryPeerHQ", "support@sentrypeer.com"})
    |> render_body("email_welcome.html", %{name: user.name})
    |> premail()
    |> Mailer.deliver()
  end

  # Inline CSS so it works in all browsers
  def premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
