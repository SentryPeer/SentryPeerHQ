defmodule Sentrypeer.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :auth_id, :string
      add :client_id, :string

      timestamps()
    end

    create index(:clients, [:auth_id])
    create index(:clients, [:client_id])
    create unique_index(:clients, [:auth_id, :client_id])
  end
end
