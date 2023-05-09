defmodule Sentrypeer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :auth_id, :string, null: false
      add :latest_login, :naive_datetime
      timestamps()
    end

    create unique_index(:users, :auth_id)
  end
end
