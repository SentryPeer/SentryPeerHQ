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

defmodule Sentrypeer.CustomerNodes.Node do
  @moduledoc false

  defstruct [:node_name, :description]
  @types %{node_name: :string, description: :string}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = node, attrs) do
    {node, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:node_name, :description])
    |> validate_format(:node_name, ~r/^[a-zA-Z0-9_-]+$/)
    |> validate_length(:node_name, min: 3, max: 20)
    |> validate_length(:description, min: 3, max: 100)
  end
end
