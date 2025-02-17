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

defmodule Sentrypeer.Auth.Token do
  @moduledoc """
  Customizes the Joken config to verify and validate claims.
  """
  use Joken.Config, default_signer: nil

  alias Sentrypeer.Auth.{Auth0Config, Auth0Strategy}

  add_hook(JokenJwks, strategy: Auth0Strategy)

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("iss", nil, &(&1 == iss()))
    |> add_claim("aud", nil, &verify_audience/1)
  end

  defp verify_audience(audience) when is_binary(audience) do
    aud() == audience
  end

  defp verify_audience(audience) when is_list(audience) do
    aud() in audience
  end

  defp iss, do: Auth0Config.auth0_base_url()
  defp aud, do: Auth0Config.auth0_audience()
end
