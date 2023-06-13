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

defmodule Sentrypeer.ContactForm.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator

  @moduledoc """
  The Contact schema.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contacts" do
    field :company_name, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :message, :binary

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :company_name, :email, :message])
    |> validate_required([:first_name, :last_name, :email, :message])
    |> validate_length(:company_name, min: 3, max: 20)
    |> validate_email(:email, checks: [:html_input, :burner, :check_mx_record])
    |> validate_length(:first_name, min: 3, max: 20)
    |> validate_length(:last_name, min: 3, max: 20)
    |> validate_length(:message, min: 3, max: 1000)
  end
end
