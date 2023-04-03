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

defmodule Sentrypeer.CustomerClients.Client do
  @moduledoc false

  defstruct [:client_name, :client_description]
  @types %{client_name: :string, client_description: :string}

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
