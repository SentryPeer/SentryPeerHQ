# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.ActivityLogs do
  @moduledoc """
  The ActivityLogs context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.ActivityLogs.ActivityLog

  @doc """
  Returns the list of activity_logs.

  ## Examples

      iex> list_activity_logs()
      [%ActivityLog{}, ...]

  """
  def list_activity_logs do
    Repo.all(ActivityLog)
  end

  @doc """
  Gets a single activity_log.

  Raises `Ecto.NoResultsError` if the Activity log does not exist.

  ## Examples

      iex> get_activity_log!(123)
      %ActivityLog{}

      iex> get_activity_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_log!(id), do: Repo.get!(ActivityLog, id)

  @doc """
  Creates a activity_log.

  ## Examples

      iex> create_activity_log(%{field: value})
      {:ok, %ActivityLog{}}

      iex> create_activity_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_log(attrs \\ %{}) do
    %ActivityLog{}
    |> ActivityLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_log.

  ## Examples

      iex> update_activity_log(activity_log, %{field: new_value})
      {:ok, %ActivityLog{}}

      iex> update_activity_log(activity_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_log(%ActivityLog{} = activity_log, attrs) do
    activity_log
    |> ActivityLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_log.

  ## Examples

      iex> delete_activity_log(activity_log)
      {:ok, %ActivityLog{}}

      iex> delete_activity_log(activity_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_log(%ActivityLog{} = activity_log) do
    Repo.delete(activity_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_log changes.

  ## Examples

      iex> change_activity_log(activity_log)
      %Ecto.Changeset{data: %ActivityLog{}}

  """
  def change_activity_log(%ActivityLog{} = activity_log, attrs \\ %{}) do
    ActivityLog.changeset(activity_log, attrs)
  end
end
