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

defmodule Sentrypeer.SentrypeerEvents do
  @moduledoc """
  The SentrypeerEvents context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent
  alias Sentrypeer.SentrypeerIpAddress
  alias Sentrypeer.SentrypeerPhoneNumber

  @doc """
  Returns the list of sentrypeerevents.

  ## Examples

      iex> list_sentrypeerevents()
      [%SentrypeerEvent{}, ...]

  """
  def list_sentrypeerevents do
    Repo.all(SentrypeerEvent)
  end

  @doc """
  Gets a single sentrypeer_event.

  Raises `Ecto.NoResultsError` if the Sentrypeer event does not exist.

  ## Examples

      iex> get_sentrypeer_event!(123)
      %SentrypeerEvent{}

      iex> get_sentrypeer_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sentrypeer_event!(id), do: Repo.get!(SentrypeerEvent, id)

  @doc """
  Creates a sentrypeer_event.

  ## Examples

      iex> create_sentrypeer_event(%{field: value})
      {:ok, %SentrypeerEvent{}}

      iex> create_sentrypeer_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sentrypeer_event(attrs \\ %{}, client_id) do
    %SentrypeerEvent{}
    |> SentrypeerEvent.changeset(attrs, client_id)
    |> Repo.insert()
  end

  @doc """
  Deletes a sentrypeer_event.

  ## Examples

      iex> delete_sentrypeer_event(sentrypeer_event)
      {:ok, %SentrypeerEvent{}}

      iex> delete_sentrypeer_event(sentrypeer_event)
      {:error, %Ecto.Changeset{}}

  @doc \"""
  Check a phone number that has been submitted via a sentrypeer_event exists

  Returns true if exists, false if it does not

  ## Examples

      iex> check_phone_number_sentrypeer_event?("0800800800")
      true

      iex> check_phone_number_sentrypeer_event?("0800800800")
      false

  """
  def check_phone_number_sentrypeer_event?(phone_number, client_id) do
    changeset =
      SentrypeerPhoneNumber.changeset(%SentrypeerPhoneNumber{}, %{phone_number: phone_number})

    if changeset.valid? do
      query =
        from e in SentrypeerEvent,
          where: e.called_number == ^changeset.changes.phone_number

      # and
      #  e.client_id == ^client_id

      Repo.exists?(query)
    else
      false
    end
  end

  @doc """
  Check an ip_address that has been submitted via a sentrypeer_event exists

  Returns true if exists, false if it does not

  ## Examples

      iex> check_ip_address_sentrypeer_event?("127.0.0.1")
      true

      iex> check_ip_address_sentrypeer_event?("127.0.0.1")
      false

  """
  def check_ip_address_sentrypeer_event?(ip_address, client_id) do
    changeset = SentrypeerIpAddress.changeset(%SentrypeerIpAddress{}, %{ip_address: ip_address})

    if changeset.valid? do
      query =
        from e in SentrypeerEvent,
          where: e.source_ip == ^changeset.changes.ip_address

      # and
      #  e.client_id == ^client_id

      Repo.exists?(query)
    else
      false
    end
  end
end
