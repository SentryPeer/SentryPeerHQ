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

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  scope "/auth", SentrypeerWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # use Kaffy.Routes, scope: "/admin", pipe_through: [:admins_only]

  live_session :default, on_mount: SentrypeerWeb.UserLiveAuth do
    scope "/", SentrypeerWeb do
      pipe_through [:browser, :admins_only, :ensure_authenticated_user]
      live "/dashboard", CustomerDashboardLive.Index, :index
    end
  end

  scope "/", SentrypeerWeb do
    pipe_through [:browser, :admins_only]

    get "/", PageController, :home

    # Auth
    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  scope "/api", SentrypeerWeb do
    pipe_through [:api, :api_authorization]

    resources "/events", SentrypeerEventController, only: [:create]
    get "/phone-numbers/:phone_number", SentrypeerEventController, :check_phone_number
    get "/ip-addresses/:ip_address", SentrypeerEventController, :check_ip_address
  end

  # Enables a password protected LiveDashboard
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/admin-dashboard", metrics: SentrypeerWeb.Telemetry
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
