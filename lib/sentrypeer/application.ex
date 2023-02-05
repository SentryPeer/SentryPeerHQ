defmodule Sentrypeer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SentrypeerWeb.Telemetry,
      # Start the Ecto repository
      Sentrypeer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sentrypeer.PubSub},
      # Start Finch
      {Finch, name: Sentrypeer.Finch},
      # Start the Endpoint (http/https)
      SentrypeerWeb.Endpoint,
      # Start a worker by calling: Sentrypeer.Worker.start_link(arg)
      # {Sentrypeer.Worker, arg}
      Sentrypeer.Auth.Auth0Strategy
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sentrypeer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SentrypeerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
