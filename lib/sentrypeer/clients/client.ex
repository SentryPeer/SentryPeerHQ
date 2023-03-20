defmodule Sentrypeer.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :auth_id, :string
    field :client_id, :string

    has_many :events, Sentrypeer.SentrypeerEvents.SentrypeerEvent, foreign_key: :client_id, references: :client_id

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:auth_id, :client_id])
    |> validate_required([:auth_id, :client_id])
  end
end
