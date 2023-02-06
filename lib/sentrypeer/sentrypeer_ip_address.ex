defmodule Sentrypeer.SentrypeerIpAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentrypeer.SentrypeerIpAddress
  alias IP

  embedded_schema do
    field :ip_address, :string
  end

  defp validate_ip_address(:ip_address, ip_address) do
    case IP.from_string(ip_address) do
      {:ok, _} ->
        []

      {:error, :einval} ->
        [ip_address: "Invalid IP Address"]
    end
  end

  @doc false
  def changeset(%SentrypeerIpAddress{} = sentrypeer_ip_address, attrs) do
    sentrypeer_ip_address
    |> cast(attrs, [:ip_address])
    |> validate_change(:ip_address, &validate_ip_address/2)
    |> validate_required([:ip_address])
  end
end
