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

defmodule SentrypeerWeb.Router do
  use SentrypeerWeb, :router

  alias Sentrypeer.Auth.Permissions

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SentrypeerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_authenticated_user do
    plug :browser
    plug SentrypeerWeb.AuthPlug
  end

  pipeline :api_authorization do
    plug Sentrypeer.Auth.Authorize
  end

  pipeline :api_permission_write_events do
    plug Sentrypeer.Auth.ValidatePermission, Permissions.write_events()
  end

  pipeline :api_permission_read_phone_numbers do
    plug Sentrypeer.Auth.ValidatePermission, Permissions.read_phone_numbers()
  end

  pipeline :api_permission_read_ip_addresses do
    plug Sentrypeer.Auth.ValidatePermission, Permissions.read_ip_addresses()
  end

  pipeline :rate_limit_per_hour do
    plug SentrypeerWeb.RateLimitPlug, max_requests: 7200, interval_seconds: 3600
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  # As per https://hexdocs.pm/fun_with_flags_ui/readme.html#mounted-in-another-plug-application
  pipeline :flags do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
    plug :fetch_session
  end

  scope "/auth", SentrypeerWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  use Kaffy.Routes, scope: "/crm", pipe_through: [:admins_only]
  # layout: {SentrypeerWeb.Layouts, :main_app}

  live_session :default,
    root_layout: {SentrypeerWeb.Layouts, :liveview_root},
    on_mount: [SentrypeerWeb.UserLiveAuth, SentrypeerWeb.ActiveNav] do
    scope "/", SentrypeerWeb do
      pipe_through [:browser, :admins_only, :ensure_authenticated_user]
      live "/dashboard", CustomerDashboardLive.Index, :index

      # SentryPeer nodes that the user owns - https://sentrypeer.org is the node software used to contribute their
      # own data
      live "/nodes", CustomerNodesLive.Index, :index
      live "/nodes/new", CustomerNodesLive.Index, :new
      live "/nodes/:client_id", CustomerNodesLive.Overview, :overview
      live "/nodes/:client_id/edit", CustomerNodesLive.Index, :edit
      live "/nodes/:client_id/delete", CustomerNodesLive.Index, :delete

      live "/analytics", CustomerAnalyticsLive.Index, :index
      live "/insights", CustomerInsightsLive.Index, :index
      live "/billing", CustomerBillingLive.Index, :index
      live "/team", CustomerTeamLive.Index, :index
      live "/integrations", CustomerIntegrationsLive.Index, :index

      live "/settings", CustomerSettingsLive.Index, :index
      live "/settings/new", CustomerSettingsLive.Index, :new
      live "/settings/:client_id", CustomerSettingsLive.Overview, :overview
      live "/settings/:client_id/edit", CustomerSettingsLive.Index, :edit
      live "/settings/:client_id/delete", CustomerSettingsLive.Index, :delete

      live "/user/profile", UserProfileLive.Index, :index
      live "/user/settings", UserSettingsLive.Index, :index
    end
  end

  scope "/", SentrypeerWeb do
    pipe_through [:browser, :admins_only]

    # Home page
    live "/", HomeLive.Index, :index

    # Home page top nav
    get "/partners", PageController, :partners
    get "/about", PageController, :about

    # Subscription pricing
    get "/pricing", PricingController, :index

    # Where we handle subscriptions
    post "/pricing/new", PricingController, :new

    # Where to send our users when they've exited the Stripe session
    get "/pricing/new/success", PricingController, :success
    get "/pricing/new/cancel", PricingController, :cancel

    # Home page bottom nav
    get "/jobs", PageController, :jobs

    # Support
    get "/documentation", PageController, :documentation
    get "/guides", PageController, :guides

    # Sectors
    get "/advanced-users", PageController, :advanced_users
    get "/internet-telephony-service-provider", PageController, :itsps
    get "/cybersecurity", PageController, :cybersecurity
    get "/telecom-resellers", PageController, :telecom_resellers

    # Legal
    get "/privacy-policy", PageController, :privacy_policy
    get "/terms-and-conditions", PageController, :terms_and_conditions
    get "/acceptable-use-policy", PageController, :acceptable_use_policy
    get "/cookie-policy", PageController, :cookie_policy

    # Contact Us
    live "/contact", ContactLive.Index, :index
    live "/contact/new", ContactLive.Index, :new

    # Auth
    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
    get "/signup", AuthController, :signup
  end

  scope "/api", SentrypeerWeb do
    pipe_through [:rate_limit_per_hour, :api, :api_authorization, :api_permission_write_events]
    resources "/events", SentrypeerEventController, only: [:create]
  end

  scope "/api", SentrypeerWeb do
    pipe_through [
      :rate_limit_per_hour,
      :api,
      :api_authorization,
      :api_permission_read_phone_numbers
    ]

    get "/phone-numbers/:phone_number", SentrypeerEventController, :check_phone_number
  end

  scope "/api", SentrypeerWeb do
    pipe_through [
      :rate_limit_per_hour,
      :api,
      :api_authorization,
      :api_permission_read_ip_addresses
    ]

    get "/ip-addresses/:ip_address", SentrypeerEventController, :check_ip_address
  end

  # Enables a password protected LiveDashboard
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/ops-dashboard", metrics: SentrypeerWeb.Telemetry
  end

  scope path: "/flags" do
    pipe_through [:flags, :admins_only]
    forward "/", FunWithFlags.UI.Router, namespace: "flags"
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("SENTRYPEER_ADMIN_AUTH_USERNAME")
    password = System.fetch_env!("SENTRYPEER_ADMIN_AUTH_PASSWORD")

    Plug.BasicAuth.basic_auth(conn,
      username: username,
      password: password,
      realm: "SentryPeer Demo"
    )
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:sentrypeer, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
