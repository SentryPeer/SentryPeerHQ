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

defmodule Sentrypeer.Integrations.Integration do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  The Integration schema.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "integrations" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :subject, :string
    field :message, :string
    field :url, :string
    field :enabled, :boolean, default: true
    field :auth_id, :binary_id

    belongs_to :user, Sentrypeer.Accounts.User,
      foreign_key: :auth_id,
      define_field: false,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(integration, attrs) do
    integration
    |> cast(attrs, [:name, :description, :type, :subject, :message, :url, :enabled, :auth_id])
    |> validate_required([
      :name,
      :description,
      :type,
      :subject,
      :message,
      :url,
      :enabled,
      :auth_id
    ])
  end
end
