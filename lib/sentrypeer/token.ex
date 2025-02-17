# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.Token do
  @moduledoc """
  Handles creating and validating Phoenix.Token tokens for email confirmation etc.
  See https://hexdocs.pm/phoenix/Phoenix.Token.html for more information.

  This is not an Auth0 JWT token. See Sentrypeer.Auth.Token for that.
  """

  def generate_token(payload) do
    Phoenix.Token.sign(
      SentrypeerWeb.Endpoint,
      get_secret_key_base(),
      payload
    )
  end

  def verify_token(token) do
    Phoenix.Token.verify(
      SentrypeerWeb.Endpoint,
      get_secret_key_base(),
      token,
      # 24 hours
      max_age: 86_400
    )
  end

  defp get_secret_key_base do
    Application.get_env(:sentrypeer, SentrypeerWeb.Endpoint)[:secret_key_base]
  end
end
