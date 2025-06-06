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

defmodule Sentrypeer.Accounts.UserFromAuth do
  require Logger
  require Poison

  alias Sentrypeer.Accounts
  alias Sentrypeer.Auth.Auth0User
  alias Sentrypeer.Emails.EmailError
  alias Sentrypeer.Mailer
  alias Ueberauth.Auth

  @moduledoc """
  Retrieve the user information from an auth request
  """

  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    # Check if the user already exists (and is enabled), if not create them
    # and return the basic info.
    #
    # We can always just block the user account on Auth0 anyway, but this
    # way we can do it ourselves if a subscription is cancelled etc.
    case Accounts.find_or_create_user(%{
           auth_id: auth.uid,
           email: email_from_auth(auth),
           latest_login: DateTime.utc_now()
         }) do
      nil ->
        EmailError.notify_admins(
          __MODULE__,
          "User account exists, but has been disabled by us.",
          auth.uid
        )
        |> Mailer.deliver()

        {:error, "Your account has been disabled. Please contact us."}

      _user ->
        {:ok, basic_info(auth)}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # Google does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warning(auth.provider <> " needs to find an avatar URL!")
    Logger.debug(Poison.encode!(auth))
    nil
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  defp basic_info(auth) do
    Logger.debug("Auth: " <> Poison.encode!(auth))

    %Auth0User{
      id: auth.uid,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth),
      email: email_from_auth(auth),
      latest_login: DateTime.utc_now()
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
