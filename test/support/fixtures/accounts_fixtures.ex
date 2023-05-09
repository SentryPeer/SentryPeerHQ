defmodule Sentrypeer.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        auth_id: "some auth_id",
        latest_login: ~N[2023-05-08 17:24:00]
      })
      |> Sentrypeer.Accounts.create_user()

    user
  end
end
