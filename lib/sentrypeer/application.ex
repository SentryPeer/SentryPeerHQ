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

defmodule Sentrypeer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Appsignal.Phoenix.LiveView

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []
    LiveView.attach()

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
      Sentrypeer.Auth.Auth0Strategy,
      {Oban, oban_config()},
      # Our Cloak Vault
      Sentrypeer.Vault,
      # Our Cache
      {Cachex, name: :sentrypeer_cache},
      # https://fly.io/docs/elixir/the-basics/clustering/#adding-libcluster
      # Setup for clustering
      {Cluster.Supervisor, [topologies, [name: Sentrypeer.ClusterSupervisor]]},
      # For async tasks etc. We use for Sentrypeer.Alerts.
      {Task.Supervisor, name: Sentrypeer.TaskSupervisor}
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

  defp oban_config do
    Application.fetch_env!(:sentrypeer, Oban)
  end
end
