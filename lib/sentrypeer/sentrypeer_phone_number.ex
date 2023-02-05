defmodule Sentrypeer.SentrypeerPhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentrypeer.SentrypeerPhoneNumber

  embedded_schema do
    field :phone_number, :string
  end

  @doc false
  def changeset(%SentrypeerPhoneNumber{} = sentrypeer_phone_number, attrs) do
    sentrypeer_phone_number
    |> cast(attrs, [:phone_number])
    |> validate_required([:phone_number])
  end
end
