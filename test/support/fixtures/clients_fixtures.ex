defmodule Sentrypeer.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.Clients` context.
  """

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(%{
        auth_id: "some auth_id",
        client_id: "some client_id"
      })
      |> Sentrypeer.Clients.create_client()

    client
  end
end
