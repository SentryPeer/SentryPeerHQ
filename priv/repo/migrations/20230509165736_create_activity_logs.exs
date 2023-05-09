defmodule Sentrypeer.Repo.Migrations.CreateActivityLogs do
  use Ecto.Migration

  def change do
    create table(:activity_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ip_address, :string
      add :user_agent, :string
      add :event, :string
      add :data, :map
      add :auth_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:activity_logs, [:auth_id])
  end
end
