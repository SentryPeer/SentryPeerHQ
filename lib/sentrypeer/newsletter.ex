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

  @list_id System.get_env("SENTRYPEER_MAILCHIMP_LIST_ID")
  @api_key System.get_env("SENTRYPEER_MAILCHIMP_API_KEY")
  @api_server System.get_env("SENTRYPEER_MAILCHIMP_API_SERVER")
  @api_url "https://#{@api_server}.api.mailchimp.com/3.0/lists/#{@list_id}/members"

  def subscribe(email) do
    submit_to_mailchimp_api(email)
  end

  defp submit_to_mailchimp_api(email) do
    HTTPoison.post!(
      @api_url,
      Jason.encode!(%{
        email_address: email,
        status: "pending"
      }),
      ["Content-Type": "application/json"],
      ssl: [
        {:versions, [:"tlsv1.2"]}
      ],
      recv_timeout: 2000,
      hackney: [basic_auth: {"key", @api_key}]
    )
  end
end
