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

defmodule Sentrypeer.Repo.Migrations.CreateSentrypeerevents do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create table(:sentrypeerevents, primary_key: false) do
      add :app_name, :text, null: false
      add :app_version, :text, null: false
      add :event_timestamp, :timestamptz, null: false
      add :event_uuid, :uuid, null: false
      add :created_by_node_id, :uuid, null: false
      add :collected_method, :text, null: false
      add :transport_type, :text, null: false
      add :source_ip, :text, null: false
      add :destination_ip, :text, null: false
      add :called_number, :text, null: false
      add :sip_method, :text, null: false
      add :sip_user_agent, :text, null: false
      add :sip_message, :text, null: false
      add :username, :text, null: false

      timestamps(type: :timestamptz)
    end

    execute("SELECT create_hypertable('sentrypeerevents', 'event_timestamp')")

    # https://hexdocs.pm/ecto/Ecto.Changeset.html#unique_constraint/3-complex-constraints
    create unique_index(:sentrypeerevents, [:event_uuid, :event_timestamp],
             name: :sentrypeerevents_event_uuid_event_timestamp_in
           )

    create index(:sentrypeerevents, [:source_ip])
    create index(:sentrypeerevents, [:called_number])
    create index(:sentrypeerevents, [:username])
  end

  def down do
    drop table(:sentrypeerevents)
    execute("DROP EXTENSION IF EXISTS timescaledb")
  end
end
