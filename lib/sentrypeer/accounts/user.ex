defmodule Sentrypeer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :auth_id, :string
    field :latest_login, :naive_datetime
    field :enabled, :boolean

    has_one :billing_subscription, Sentrypeer.BillingSubscriptions.BillingSubscription,
      foreign_key: :auth_id,
      references: :auth_id

    has_many :clients, Sentrypeer.Clients.Client,
      foreign_key: :auth_id,
      references: :auth_id

    has_many :activity_logs, Sentrypeer.ActivityLogs.ActivityLog,
      foreign_key: :auth_id,
      references: :auth_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:auth_id, :latest_login])
    |> validate_required([:auth_id, :latest_login])
    |> unique_constraint(:auth_id, name: :users_auth_id_index)
  end
end
