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

defmodule Sentrypeer.CustomerClients do
  @moduledoc """
  The clients context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.Clients
  alias Sentrypeer.CustomerClients.Client
  alias Sentrypeer.Plans

  require Logger

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{data: %Client{}}

  """
  def change_client(%Client{} = client, attrs \\ %{}) do
    Client.changeset(client, attrs)
  end

  @doc """
  Returns true if the user is allowed to create more clients, false if not.

  ## Examples

      iex> is_allowed_more_clients!(auth_id)
      true

  """
  def is_allowed_more_api_clients?(auth_id) do
    case Auth0ManagementAPI.list_clients_by_user(auth_id, "api_client") do
      {:ok, clients} ->
        total_clients = length(clients)
        Logger.debug("Total clients for #{auth_id} is: #{total_clients}")

        my_plan = Plans.what_plan_am_i_on(auth_id)
        Logger.debug("User #{auth_id} is on plan: #{inspect(my_plan)}")

        my_total_allowed_clients = List.first(my_plan).api_clients
        Logger.debug("My total allowed clients is: #{my_total_allowed_clients}")

        # On a plan that returns :unlimited for api_clients, this still works.
        if total_clients < my_total_allowed_clients do
          # They can create more
          true
        else
          # They can't create more
          false
        end

      {:error, _error} ->
        # Block them here just in case of an Auth0 issue
        true
    end
  end

  def create_client(auth_id, client_type, attrs \\ %{}) do
    changeset = Client.changeset(%Client{}, attrs)

    if changeset.valid? do
      case Auth0ManagementAPI.create_client(
             auth_id,
             changeset.changes.client_name,
             changeset.changes.client_description,
             client_type
           ) do
        {:ok, body} ->
          {:ok, client} = Jason.decode(body)
          Logger.debug("Saving client user association: #{inspect(client)}")

          # credo:disable-for-next-line
          case Auth0ManagementAPI.create_client_grant(client["client_id"], client_type) do
            {:ok, _body} ->
              Logger.debug("Saved client grant")

            {:error, error} ->
              {:error, error}
          end

          Clients.create_client(%{
            client_id: client["client_id"],
            auth_id: auth_id,
            client_type: client_type
          })

        {:error, error} ->
          {:error, error}
      end
    else
      # We have to manually set the action to :validate (or any other value to show errors)
      # https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#form/1-a-note-on-errors
      #
      # Or use, but then we need to import Ecto.Changeset
      # https://hexdocs.pm/ecto/Ecto.Changeset.html#apply_action/2
      changeset = changeset |> Map.put(:action, :validate)
      {:error, changeset}
    end
  end

  def update_client(auth_id, client_id, attrs \\ %{}) do
    changeset = Client.changeset(%Client{}, attrs)

    if changeset.valid? do
      case Auth0ManagementAPI.update_client_for_user(
             auth_id,
             client_id,
             changeset.changes.client_name,
             changeset.changes.client_description
           ) do
        {:ok, body} ->
          Logger.debug("Updated client: #{inspect(body)}")
          {:ok, _client} = Jason.decode(body)

        {:error, error} ->
          {:error, error}
      end
    else
      # See above for why we do this
      changeset = changeset |> Map.put(:action, :validate)
      {:error, changeset}
    end
  end
end
