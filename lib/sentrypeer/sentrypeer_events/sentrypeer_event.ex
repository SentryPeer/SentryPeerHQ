# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2024 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.SentrypeerEvents.SentrypeerEvent do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.UUID

  @moduledoc """
  The SentrypeerEvent schema.
  """

  @allowed_fields [
    :app_name,
    :app_version,
    :called_number,
    :collected_method,
    :created_by_node_id,
    :destination_ip,
    :event_timestamp,
    :event_uuid,
    :sip_message,
    :sip_method,
    :sip_user_agent,
    :source_ip,
    :transport_type
  ]

  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false
  schema "sentrypeerevents" do
    field :app_name, :string
    field :app_version, :string
    field :called_number, :string
    field :collected_method, :string
    field :created_by_node_id, Ecto.UUID
    field :destination_ip, :string
    field :event_timestamp, :utc_datetime_usec
    field :event_uuid, Ecto.UUID
    field :sip_message, :string
    field :sip_method, :string
    field :sip_user_agent, :string
    field :source_ip, :string
    field :transport_type, :string
    # Used to look up user IDs in Auth0 management API
    field :client_id, :string
    field :third_party, :boolean, default: false

    belongs_to :client, Sentrypeer.Clients.Client,
      foreign_key: :id,
      define_field: false,
      references: :client_id

    timestamps(type: :utc_datetime_usec)
  end

  defp cast_uuid(uuid) do
    case Ecto.UUID.cast(uuid) do
      {:ok, valid_uuid} ->
        {Ecto.UUID.cast(uuid)}
        valid_uuid

      :error ->
        {:error, "Invalid UUID"}
    end
  end

  @doc false
  def changeset(sentrypeer_event, attrs, client_id, third_party) do
    # Due to TimescaleDB's unique constraint, we need to cast the event_uuid and
    # event_timestamp to Ecto.UUID and Ecto.NaiveDateTime, respectively.
    # See https://hexdocs.pm/ecto/Ecto.Changeset.html#unique_constraint/3-partitioning
    sentrypeer_event
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    # Manually add client_id that we add in from the controller
    |> put_change(:client_id, client_id)
    # Manually add third_party that we determine in Sentrypeer.SentrypeerEvents
    |> put_change(:third_party, third_party)
    |> put_change(:created_by_node_id, cast_uuid(attrs["created_by_node_id"]))
    |> put_change(:event_uuid, cast_uuid(attrs["event_uuid"]))
    |> unique_constraint([:event_uuid, :event_timestamp],
      name: :sentrypeerevents_event_uuid_event_timestamp_in,
      match: :suffix
    )
  end
end
