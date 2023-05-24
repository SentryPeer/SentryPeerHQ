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

defmodule Sentrypeer.ActivityLogs.ActivityLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_logs" do
    field :data, :map
    field :event, :string
    field :ip_address, :string
    field :user_agent, :string
    field :auth_id, :binary_id

    belongs_to :user, Sentrypeer.Accounts.User,
      foreign_key: :auth_id,
      define_field: false,
      references: :auth_id

    timestamps()
  end

  @doc false
  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [:ip_address, :user_agent, :event, :data])
    |> validate_required([:ip_address, :user_agent, :event, :data])
  end
end
