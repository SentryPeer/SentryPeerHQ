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

defmodule Sentrypeer.Emails.EmailIntegrationConfirm do
  import Swoosh.Email

  alias Sentrypeer.Integrations.Integration
  alias Sentrypeer.Mailer
  require Logger

  @moduledoc """
  Send a confirmation email to the email in the Email Alert integration.
  """

  def send!(%Integration{} = integration, token) do
    Logger.debug("Sending email confirmation to #{integration.destination}")

    new()
    |> to(integration.destination)
    |> from({"SentryPeer Support", "support@sentrypeer.com"})
    |> subject("SentryPeer Email Alert Confirmation")
    |> html_body("""
    <p>Hi there,</p>
    <p>Thanks for enabling SentryPeer Email Alerts.</p>
    <p>Please click the link below to confirm your email address:</p>
    <p><a href="https://sentrypeer.com/integrations/email/confirm/#{token}">Confirm Email</a></p>
    <p>Or copy and paste the following link into your browser:</p>
    <p>https://sentrypeer.com/integrations/email/confirm/#{token}</p>
    <p>Thanks,</p>
    <p>SentryPeer Support</p>
    """)
    |> text_body("""
    Hi there,
    Thanks for signing up to SentryPeer Email Alerts.

    Please click the link below to confirm your email address:

        https://sentrypeer.com/integrations/email/confirm/#{token}

    Thanks,
    SentryPeer Support
    """)
    |> Mailer.deliver()
  end
end
