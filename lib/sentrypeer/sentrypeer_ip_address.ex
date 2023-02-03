defmodule Sentrypeer.SentrypeerIpAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentrypeer.SentrypeerIpAddress

  embedded_schema do 
    field :ip_address, :string
  end

  @doc false
  def changeset(%SentrypeerIpAddress{} = sentrypeer_ip_address, attrs) do
    sentrypeer_ip_address
    |> cast(attrs, [:ip_address])
    |> validate_required([:ip_address])
  end
end
