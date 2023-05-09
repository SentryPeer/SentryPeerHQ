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

defmodule Sentrypeer.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :auth_id, :string
    field :client_id, :string
    field :client_type, :string
    field :hourly_request_limit, :integer, default: 600

    belongs_to :user, Sentrypeer.Accounts.User,
      foreign_key: :auth_id,
      references: :auth_id,
      define_field: false

    has_many :events, Sentrypeer.SentrypeerEvents.SentrypeerEvent,
      foreign_key: :client_id,
      references: :client_id

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:auth_id, :client_id, :client_type])
    |> validate_required([:auth_id, :client_id, :client_type])
  end
end
