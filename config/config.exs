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
# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sentrypeer,
  ecto_repos: [Sentrypeer.Repo],
  generators: [binary_id: true],
  auth0_logout_url:
    System.get_env("AUTH0_DOMAIN", "authz.sentrypeer.com")
    |> String.replace_suffix(".sentrypeer.com", ".sentrypeer.com/v2/logout")
    |> String.replace_prefix("", "https://")
    |> URI.new!()
    |> URI.append_query(
      URI.encode_query(%{
        client_id: System.get_env("AUTH0_CLIENT_ID") || raise("AUTH0_CLIENT_ID is not set"),
        returnTo: System.get_env("AUTH0_LOGOUT_REDIRECT_URL", "http://localhost:4000")
      })
    )
    |> URI.to_string()

# Configures the endpoint
config :sentrypeer, SentrypeerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: SentrypeerWeb.ErrorHTML, json: SentrypeerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Sentrypeer.PubSub,
  live_view: [signing_salt: "+CZDbTTY"]

config :kaffy,
  otp_app: :sentrypeer,
  ecto_repo: Sentrypeer.Repo,
  router: SentrypeerWeb.Router

# Configures the mailer
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`. We use the SMTP adapter for development.
config :sentrypeer, Sentrypeer.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: System.get_env("SENTRYPEER_SMTP_RELAY"),
  username: System.get_env("SENTRYPEER_SMTP_USERNAME"),
  password: System.get_env("SENTRYPEER_SMTP_PASSWORD"),
  tls: :always,
  auth: :always,
  port: System.get_env("SENTRYPEER_SMTP_PORT"),
  retries: 2,
  no_mx_lookups: false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    auth0: {Ueberauth.Strategy.Auth0, []}
  ]

# Configures Ueberauth's Auth0 auth provider
config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  domain: System.get_env("AUTH0_DOMAIN") || raise("AUTH0_DOMAIN is not set"),
  client_id: System.get_env("AUTH0_CLIENT_ID") || raise("AUTH0_CLIENT_ID is not set"),
  client_secret: System.get_env("AUTH0_CLIENT_SECRET") || raise("AUTH0_CLIENT_SECRET is not set")

# Configure Cldr for localization and use of timeago/1
config :ex_cldr,
  default_backend: Sentrypeer.Cldr

# Stripe
config :stripity_stripe,
  api_key: System.get_env("SENTRYPEER_STRIPE_API_KEY"),
  signing_secret: System.get_env("SENTRYPEER_STRIPE_WEBHOOK_SIGNING_SECRET"),
  json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
