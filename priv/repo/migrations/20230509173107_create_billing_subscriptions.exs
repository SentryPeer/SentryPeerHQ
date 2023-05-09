defmodule Sentrypeer.Repo.Migrations.CreateBillingSubscriptions do
  use Ecto.Migration

  def change do
    create table(:billing_subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cancel_at, :naive_datetime
      add :cancelled_at, :naive_datetime
      add :current_period_end_at, :naive_datetime
      add :current_period_start, :naive_datetime
      add :status, :string
      add :stripe_id, :string, null: false
      add :auth_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:billing_subscriptions, [:auth_id])
    create unique_index(:billing_subscriptions, :stripe_id)

  end
end
