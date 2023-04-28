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

defmodule Sentrypeer.Auth.Auth0ManagementAPI do
  alias Sentrypeer.Auth.Auth0Config
  use HTTPoison.Base

  alias Sentrypeer.CustomerClients.Client

  require Logger

  @moduledoc """
  This module is used to interact with the Auth0 Management API:
    https://auth0.com/docs/api/management/v2

  Token requests do not count towards the rate limit/quota of m2m tokens:
    https://auth0.com/docs/secure/tokens/access-tokens/management-api-access-tokens#token-quotas
  """

  def list_users do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.get!(auth0_management_url() <> "users", headers(access_token), options())
    end
  end

  def get_user(id) do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.get!(
        auth0_management_url() <> "users/" <> id,
        headers(access_token),
        options()
      )
    end
  end

  def get_user_by_email(email) do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.get!(
        auth0_management_url() <> "users-by-email?email=" <> email,
        headers(access_token),
        options()
      )
    end
  end

  def create_user(user) do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.post!(auth0_management_url() <> "users", user, headers(access_token), options())
    end
  end

  def update_user(id, user) do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.patch!(
        auth0_management_url() <> "users/" <> id,
        user,
        headers(access_token),
        options()
      )
    end
  end

  def delete_user(id) do
    with {:ok, access_token} <- get_auth_token() do
      HTTPoison.delete!(
        auth0_management_url() <> "users/" <> id,
        headers(access_token),
        options()
      )
    end
  end

  @doc """
    https://auth0.com/docs/api/management/v2#!/Clients/get_clients
  """
  def list_clients do
    with {:ok, access_token} <- get_auth_token() do
      case HTTPoison.get(
             (auth0_management_url() <> "clients") |> list_clients_query_params(),
             headers(access_token),
             options()
           ) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body}

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          {:error, "Auth0 returned status code #{status_code} with body #{body}"}

        {:error, error} ->
          {:error, error}
      end
    end
  end

  def list_clients_by_user(user, client_type) do
    Logger.debug("Listing Auth0 clients for user #{user} of type #{client_type}")

    list_clients()
    |> case do
      {:ok, body} ->
        {:ok,
         Jason.decode!(body)
         |> Enum.filter(fn client ->
           client["client_metadata"]["auth_id"] == user &&
             client["client_metadata"]["client_type"] == client_type
         end)
         |> Enum.map(fn client ->
           client_json_to_client_struct(client)
         end)}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_client(id) do
    with {:ok, access_token} <- get_auth_token() do
      case HTTPoison.get(
             auth0_management_url() <> "clients/" <> id,
             headers(access_token),
             options()
           ) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body}

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          {:error, "Auth0 returned status code #{status_code} with body #{body}"}

        {:error, error} ->
          {:error, error}
      end
    end
  end

  def get_client_for_user(user, id) do
    Logger.debug("Getting Auth0 client #{id} for user #{user}")

    get_client(id)
    |> case do
      {:ok, body} ->
        client = Jason.decode!(body) |> client_json_to_client_struct()

        case check_client_belongs_to_user(client, user) do
          true ->
            {:ok, client}

          false ->
            Logger.info("Client #{id} does not belong to user #{user}")
            {:error, "Client #{id} does not belong to user #{user}"}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  def create_client(auth_id, name, description, client_type) do
    with {:ok, access_token} <- get_auth_token() do
      Logger.debug("Creating Auth0 client for user #{auth_id} of type #{client_type}")

      case HTTPoison.post(
             auth0_management_url() <> "clients",
             create_client_json(auth_id, name, description, client_type),
             headers(access_token),
             options()
           ) do
        {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
          {:ok, body}

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          {:error, "Auth0 returned status code #{status_code} with body #{body}"}

        {:error, error} ->
          {:error, error}
      end
    end
  end

  def delete_client(id) do
    with {:ok, access_token} <- get_auth_token() do
      case HTTPoison.delete(
             auth0_management_url() <> "clients/" <> id,
             headers(access_token),
             options()
           ) do
        {:ok, %HTTPoison.Response{status_code: 204}} ->
          {:ok, "Client deleted"}

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          {:error, "Auth0 returned status code #{status_code} with body #{body}"}

        {:error, error} ->
          {:error, error}
      end
    end
  end

  def delete_client_for_user(user, id) do
    Logger.debug("Deleting client #{id} for user #{user}")

    get_client_for_user(user, id)
    |> case do
      {:ok, _body} ->
        delete_client(id)

      {:error, error} ->
        {:error, error}
    end
  end

  def create_client_grant(client_id) do
    with {:ok, access_token} <- get_auth_token() do
      Logger.debug("Creating client grant for client #{client_id}")

      HTTPoison.post!(
        auth0_management_url() <> "client-grants",
        create_client_grant_json(client_id),
        headers(access_token),
        options()
      )
    end
  end

  def update_client_for_user(user, id, name, description) do
    Logger.debug("Updating client #{id} for user #{user}")

    get_client_for_user(user, id)
    |> case do
      {:ok, _body} ->
        update_client(user, id, name, description)

      {:error, error} ->
        {:error, error}
    end
  end

  def update_client(auth_id, id, name, description) do
    with {:ok, access_token} <- get_auth_token() do
      case HTTPoison.patch(
             auth0_management_url() <> "clients/" <> id,
             update_client_json(auth_id, name, description),
             headers(access_token),
             options()
           ) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Logger.debug("Auth0 returned body #{body}")
          {:ok, body}

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          {:error, "Auth0 returned status code #{status_code} with body #{body}"}

        {:error, error} ->
          {:error, error}
      end
    end
  end

  defp client_json_to_client_struct(client_json) do
    %Client{
      client_id: client_json["client_id"],
      client_name: client_json["name"],
      client_description: client_json["description"],
      client_secret: client_json["client_secret"],
      client_created_at: client_json["client_metadata"]["created_at"],
      client_updated_at: client_json["client_metadata"]["updated_at"],
      client_auth_id: client_json["client_metadata"]["auth_id"],
      client_type: client_json["client_metadata"]["client_type"]
    }
  end

  defp check_client_belongs_to_user(client, user) do
    client.client_auth_id == user
  end

  defp list_clients_query_params(url) do
    url
    |> URI.new!()
    |> URI.append_query(
      URI.encode_query(%{
        fields:
          "name,client_id,client_secret,client_metadata,description,app_type,is_first_party",
        is_first_party: "false",
        app_type: "non_interactive"
      })
    )
    |> URI.to_string()
  end

  defp get_auth_token do
    Logger.debug("Getting auth token from: #{Auth0Config.auth0_management_token_url()}")

    case HTTPoison.post(
           Auth0Config.auth0_management_token_url(),
           auth_token_json(),
           json_content_type(),
           options()
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.debug("Auth0 returned body #{body}")
        {:ok, Jason.decode!(body)["access_token"]}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "Auth0 returned status code #{status_code} with body #{body}"}

      {:error, error} ->
        {:error, error}
    end
  end

  defp auth_token_json do
    Jason.encode!(%{
      "client_id" => Auth0Config.auth0_management_api_client_id(),
      "client_secret" => Auth0Config.auth0_management_api_client_secret(),
      "audience" => auth0_management_url(),
      "grant_type" => "client_credentials"
    })
  end

  defp create_client_json(auth_id, name, description, client_type) do
    Jason.encode!(%{
      "name" => name,
      "description" => description,
      "grant_types" => [
        "client_credentials"
      ],
      "is_first_party" => false,
      "app_type" => "non_interactive",
      "oidc_conformant" => true,
      "jwt_configuration" => %{"alg" => "RS256"},
      "client_metadata" => %{
        "auth_id" => auth_id,
        "client_type" => client_type,
        created_at: DateTime.utc_now(),
        created_by: auth_id,
        updated_at: DateTime.utc_now(),
        updated_by: auth_id
      }
    })
  end

  defp update_client_json(auth_id, name, description) do
    Jason.encode!(%{
      "name" => name,
      "description" => description,
      "client_metadata" => %{
        "auth_id" => auth_id,
        updated_at: DateTime.utc_now(),
        updated_by: auth_id
      }
    })
  end

  defp create_client_grant_json(client_id) do
    Jason.encode!(%{
      "client_id" => client_id,
      "audience" => Auth0Config.auth0_audience(),
      # empty array means all scopes, but we'll add some read/write scopes later
      "scope" => []
    })
  end

  defp auth0_management_url do
    Auth0Config.auth0_management_api_url() <> "/api/v2/"
  end

  defp headers(access_token) do
    [
      Authorization: "Bearer #{access_token}",
      Accept: "application/json; Charset=utf-8",
      "Content-Type": "application/json"
    ]
  end

  defp json_content_type do
    [{"Content-Type", "application/json"}]
  end

  defp options do
    [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 2000]
  end
end
