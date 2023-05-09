defmodule Sentrypeer.ActivityLogs.ActivityLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_logs" do
    field :data, :map
    field :event, :string
    field :ip_address, :string
    field :user_agent, :string
    field :auth_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [:ip_address, :user_agent, :event, :data])
    |> validate_required([:ip_address, :user_agent, :event, :data])
  end
end
