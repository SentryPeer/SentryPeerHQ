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
    System.get_env("AUTH0_DOMAIN", "sentrypeer.auth0.com")
    |> String.replace_suffix(".auth0.com", ".auth0.com/v2/logout")
    |> String.replace_prefix("", "https://")
    |> URI.new!()
    |> URI.append_query(
      URI.encode_query(%{
        client_id: System.get_env("AUTH0_CLIENT_ID"),
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

#config :kaffy,
#  otp_app: :pento,
#  ecto_repo: Sentrypeer.Repo,
#  router: SentrypeerWeb.Router

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sentrypeer, Sentrypeer.Mailer, adapter: Swoosh.Adapters.Local

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
  domain: System.get_env("AUTH0_DOMAIN"),
  client_id: System.get_env("AUTH0_CLIENT_ID"),
  client_secret: System.get_env("AUTH0_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
