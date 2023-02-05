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
