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

defmodule Sentrypeer.SentrypeerPhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentrypeer.SentrypeerPhoneNumber

  @moduledoc """
  The SentrypeerPhoneNumber schema.
  """

  @primary_key false
  embedded_schema do
    field :phone_number, :string
  end

  @doc false
  def changeset(%SentrypeerPhoneNumber{} = sentrypeer_phone_number, attrs) do
    sentrypeer_phone_number
    |> cast(attrs, [:phone_number])
    # Let anything through?
    # +e164 (+ is optional)
    |> validate_format(:phone_number, ~r/^\+?[[:alnum:]]+$/)
    |> validate_required([:phone_number])
  end
end
