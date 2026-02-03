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

defmodule Sentrypeer.Newsletter do
  use HTTPoison.Base
  require Logger

  @moduledoc """
  The Newsletter module for signing up users to Mailchimp.
  """

  def subscribe(email) do
    submit_to_mailchimp_api(email)
  end

  defp submit_to_mailchimp_api(email) do
    case rate_limit_requests() do
      {:ok, count} ->
        Logger.info("Mailchimp API URL: #{api_url()}")
        Logger.info("Mailchimp rate limit at: #{count}")
        Logger.debug("Submitting email address to Mailchimp API: #{email}")
        post_email(email)

      {:error, count} ->
        Logger.info("Rate limit exceeded to protect Mailchimp API: #{count}")
    end
  end

  defp rate_limit_requests do
    ExRated.check_rate("send_to_mailchimp_api", 10_000, 5)
  end

  defp post_email(email) do
    HTTPoison.post!(
      api_url(),
      Jason.encode!(%{
        email_address: email,
        status: "pending"
      }),
      ["Content-Type": "application/json"],
      ssl: [
        {:versions, [:"tlsv1.2"]}
      ],
      recv_timeout: 2000,
      hackney: [basic_auth: {"key", api_key()}]
    )
  end

  defp list_id do
    System.get_env("SENTRYPEER_MAILCHIMP_LIST_ID")
  end

  defp api_key do
    System.get_env("SENTRYPEER_MAILCHIMP_API_KEY")
  end

  defp api_server do
    System.get_env("SENTRYPEER_MAILCHIMP_API_SERVER")
  end

  defp api_url do
    "https://#{api_server()}.api.mailchimp.com/3.0/lists/#{list_id()}/members"
  end
end
