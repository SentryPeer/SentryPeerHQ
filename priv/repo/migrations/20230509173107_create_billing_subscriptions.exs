# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.Repo.Migrations.CreateBillingSubscriptions do
  use Ecto.Migration

  def change do
    create table(:billing_subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cancel_at, :naive_datetime
      add :cancelled_at, :naive_datetime
      add :current_period_end_at, :naive_datetime
      add :current_period_start, :naive_datetime
      add :status, :string
      add :stripe_id, :string, null: false
      add :auth_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:billing_subscriptions, [:auth_id])
    create unique_index(:billing_subscriptions, :stripe_id)
  end
end
