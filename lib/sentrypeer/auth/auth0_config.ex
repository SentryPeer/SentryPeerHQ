defmodule Sentrypeer.Auth.Auth0Config do
  def auth0_audience, do: Application.get_env(:sentrypeer, :auth0_audience)

  def auth0_base_url do
    auth0_domain = Application.get_env(:sentrypeer, :auth0_domain)
    "https://#{auth0_domain}/"
  end
end
