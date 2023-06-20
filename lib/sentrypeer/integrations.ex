# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>
#
#   _____            _              _____
#  / ____|          | |            |  __ \
# | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
#  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
#  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
# |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
#                              __/ |
#                             |___/
#

defmodule Sentrypeer.Integrations do
  @moduledoc """
  The Integrations context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.Integrations.Integration

  @doc """
  Returns the list of integrations.

  ## Examples

      iex> list_integrations()
      [%Integration{}, ...]

  """
  def list_integrations do
    Repo.all(Integration)
  end

  @doc """
  Gets a single integration.

  Raises `Ecto.NoResultsError` if the Integration does not exist.

  ## Examples

      iex> get_integration!(123)
      %Integration{}

      iex> get_integration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_integration!(id), do: Repo.get!(Integration, id)

  @doc """
  Creates a integration.

  ## Examples

      iex> create_integration(%{field: value})
      {:ok, %Integration{}}

      iex> create_integration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_integration(attrs \\ %{}) do
    %Integration{}
    |> Integration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a integration.

  ## Examples

      iex> update_integration(integration, %{field: new_value})
      {:ok, %Integration{}}

      iex> update_integration(integration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_integration(%Integration{} = integration, attrs) do
    integration
    |> Integration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a integration.

  ## Examples

      iex> delete_integration(integration)
      {:ok, %Integration{}}

      iex> delete_integration(integration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_integration(%Integration{} = integration) do
    Repo.delete(integration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking integration changes.

  ## Examples

      iex> change_integration(integration)
      %Ecto.Changeset{data: %Integration{}}

  """
  def change_integration(%Integration{} = integration, attrs \\ %{}) do
    Integration.changeset(integration, attrs)
  end
end
