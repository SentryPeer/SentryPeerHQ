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

defmodule Sentrypeer.Newsletter do
  use HTTPoison.Base
  require Logger

  def subscribe(email) do
    submit_to_mailchimp_api(email)
  end

  defp submit_to_mailchimp_api(email) do
    Logger.info("Mailchimp API URL: #{api_url()}")

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
