defmodule Sentrypeer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :auth_id, :string
    field :latest_login, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:auth_id, :latest_login])
    |> validate_required([:auth_id, :latest_login])
  end
end
