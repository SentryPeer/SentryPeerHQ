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

defmodule Sentrypeer.Auth.Auth0Config do
  def auth0_audience, do: Application.get_env(:sentrypeer, :auth0_audience)

  @moduledoc """
  Gather Auth0 configuration from the environment.
  """

  def auth0_base_url do
    auth0_domain = Application.get_env(:sentrypeer, :auth0_domain)
    "https://#{auth0_domain}/"
  end

  def auth0_token_url, do: auth0_base_url() <> "oauth/token"

  def auth0_management_token_url,
    do: auth0_management_api_url() <> "/oauth/token"

  def auth0_management_api_url,
    do:
      System.get_env("AUTH0_MANAGEMENT_API_URL") ||
        raise("AUTH0_MANAGEMENT_API_URL not set")

  def auth0_management_api_client_id,
    do:
      System.get_env("AUTH0_MANAGEMENT_API_CLIENT_ID") ||
        raise("AUTH0_MANAGEMENT_API_CLIENT_ID not set")

  def auth0_management_api_client_secret,
    do:
      System.get_env("AUTH0_MANAGEMENT_API_CLIENT_SECRET") ||
        raise("AUTH0_MANAGEMENT_API_CLIENT_SECRET not set")
end
