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

defmodule Sentrypeer.SentrypeerIpAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias IP
  alias Sentrypeer.SentrypeerIpAddress

  @moduledoc """
  The SentrypeerIpAddress schema.
  """

  @primary_key false
  embedded_schema do
    field :ip_address, :string
  end

  defp validate_ip_address(:ip_address, ip_address) do
    case IP.from_string(ip_address) do
      {:ok, _} ->
        []

      {:error, :einval} ->
        [ip_address: "Invalid IP Address"]
    end
  end

  @doc false
  def changeset(%SentrypeerIpAddress{} = sentrypeer_ip_address, attrs) do
    sentrypeer_ip_address
    |> cast(attrs, [:ip_address])
    |> validate_change(:ip_address, &validate_ip_address/2)
    |> validate_required([:ip_address])
  end
end
