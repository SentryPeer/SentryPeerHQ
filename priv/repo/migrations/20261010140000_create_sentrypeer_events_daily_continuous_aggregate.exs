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

defmodule Sentrypeer.Repo.Migrations.CreateSentrypeerEventsDailyContinuousAggregate do
  use Ecto.Migration

  @disable_ddl_transaction true

  def up do
    execute("""
    CREATE MATERIALIZED VIEW IF NOT EXISTS sentrypeer_events_daily
    WITH (timescaledb.continuous) AS
    SELECT
      time_bucket('1 day', event_timestamp) AS bucket,
      count(event_uuid) AS value
    FROM sentrypeerevents
    GROUP BY bucket
    WITH NO DATA;
    """)

    execute("""
    SELECT add_continuous_aggregate_policy('sentrypeer_events_daily',
      start_offset => INTERVAL '3 days',
      end_offset => INTERVAL '1 hour',
      schedule_interval => INTERVAL '1 hour',
      if_not_exists => true);
    """)
  end

  def down do
    execute("SELECT delete_continuous_aggregate_policy('sentrypeer_events_daily', if_exists => true);")
    execute("DROP MATERIALIZED VIEW IF EXISTS sentrypeer_events_daily CASCADE;")
  end
end
