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
defmodule Sentrypeer.MixProject do
  use Mix.Project

  def project do
    [
      app: :sentrypeer,
      version: "1.0.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sentrypeer.Application, []},
      extra_applications: [:logger, :runtime_tools, :ex_rated, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 2.6"},
      {:appsignal_phoenix, "~> 2.3.2"},
      {:cachex, "~> 3.6"},
      {:certifi, "~> 2.4"},
      {:cloak_ecto, "~> 1.2.0"},
      {:contex, "~> 0.5.0"},
      {:cors_plug, "~> 3.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto_commons, "~> 0.3.3"},
      {:ecto_psql_extras, "~> 0.7"},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:ex_cldr, "~> 2.33"},
      {:ex_cldr_dates_times, "~> 2.0"},
      {:ex_cldr_numbers, "~> 2.0"},
      {:ex_rated, "~> 2.1"},
      {:finch, "~> 0.14"},
      {:floki, "~> 0.35.0"},
      {:fun_with_flags, "~> 1.11.0"},
      {:fun_with_flags_ui, "~> 0.8"},
      {:gen_smtp, "~> 1.1"},
      {:gettext, "~> 0.20"},
      {:heroicons, "~> 0.5.3"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.3"},
      {:joken, "~> 2.6.0"},
      {:joken_jwks, "~> 1.6.0"},
      {:kaffy, "~> 0.10.0"},
      {:libcluster, "~> 3.3"},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},
      {:net_address, "~> 0.3.0"},
      {:oban, "~> 2.17.0"},
      {:phoenix, "~> 1.7.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.0"},
      {:phoenix_swoosh, "~> 1.0"},
      # Required for kaffy - https://github.com/aesmail/kaffy/pull/263/files#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5
      {:phoenix_view, "~> 2.0.2"},
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 5.0"},
      {:postgrex, ">= 0.0.0"},
      {:premailex, "~> 0.3.0"},
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: false},
      {:ssl_verify_fun, "~> 1.1"},
      {:stripity_stripe, "~> 3.0"},
      {:swoosh, "~> 1.3"},
      {:tailwind, "~> 0.2.1", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:ueberauth, "~> 0.10.3"},
      {:ueberauth_auth0, "~> 2.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
