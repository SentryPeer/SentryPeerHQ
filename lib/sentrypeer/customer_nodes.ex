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

    if changeset.valid? do
      Auth0ManagementAPI.create_client(
        auth_id,
        changeset.changes.node_name,
        changeset.changes.description
      )
    else
      changeset
    end
  end
end
