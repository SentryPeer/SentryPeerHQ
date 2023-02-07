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

defmodule Sentrypeer.Auth.Auth0Strategy do
  @moduledoc """
  Defines a custom Strategy for JokenJwks using a custom jwks domain.
  """
  use JokenJwks.DefaultStrategyTemplate
  alias Sentrypeer.Auth.Auth0Config

  def init_opts(opts) do
    Keyword.merge(opts, jwks_url: jwks_url())
  end

  defp jwks_url do
    auth0_domain() <> ".well-known/jwks.json"
  end

  defp auth0_domain do
    Auth0Config.auth0_base_url()
  end
end
