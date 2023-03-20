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

defmodule Sentrypeer.CustomerNodes do
  @moduledoc """
  The Nodes context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.CustomerNodes.Node
  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.Clients

  require Logger

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{data: %Node{}}

  """
  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end

  def create_node(auth_id, attrs \\ %{}) do
    changeset = Node.changeset(%Node{}, attrs)
    Logger.debug("Create node changeset: #{inspect(changeset)}")

    if changeset.valid? do
      case Auth0ManagementAPI.create_client(
             auth_id,
             changeset.changes.node_name,
             changeset.changes.description
           ) do
        {:ok, body} ->
          {:ok, client} = Jason.decode(body)
          Logger.debug("Saving client user association: #{inspect(client)}")
          Clients.create_client(%{client_id: client["client_id"], auth_id: auth_id})

        {:error, error} ->
          {:error, error}
      end
    else
      changeset
    end
  end
end
