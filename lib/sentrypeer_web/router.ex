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

  scope "/", SentrypeerWeb do
    pipe_through [:browser, :ensure_authenticated_user]
    live "/dashboard", CustomerDashboardLive.Index, :index
  end

  scope "/", SentrypeerWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Auth
    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  scope "/api", SentrypeerWeb do
    pipe_through :api
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
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:sentrypeer, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
