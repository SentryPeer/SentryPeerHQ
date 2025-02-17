# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.CustomerClients.Client do
  @moduledoc false

  defstruct [
    :client_id,
    :client_name,
    :client_description,
    :client_secret,
    :client_created_at,
    :client_updated_at,
    :client_auth_id,
    :client_type
  ]

  @types %{
    client_id: :string,
    client_name: :string,
    client_description: :string,
    client_secret: :string,
    client_created_at: :string,
    client_updated_at: :string,
    client_auth_id: :string,
    client_type: :string
  }

  import Ecto.Changeset

  def changeset(%__MODULE__{} = client, attrs) do
    {client, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:client_name, :client_description])
    |> validate_format(:client_name, ~r/^[a-zA-Z0-9_-]+$/)
    |> validate_length(:client_name, min: 3, max: 20)
    |> validate_length(:client_description, min: 3, max: 100)
  end
end
