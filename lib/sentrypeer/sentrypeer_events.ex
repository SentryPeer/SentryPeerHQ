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

  require Logger

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
  Gets the total phone numbers seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_phone_numbers_for_client!(123)
      213

      iex> total_phone_numbers_for_client!(456)
      0

  """
  def total_unique_phone_numbers_for_client!(client_id) do
    query = from s in SentrypeerEvent, where: s.client_id == ^client_id, distinct: s.called_number
    Repo.aggregate(query, :count, :called_number)
  end

  @doc """
  Gets the total IP addresses seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_ip_addresses_for_client!(123)
      213

      iex> total_ip_addresses_for_client!(456)
      0

  """
  def total_unique_ip_addresses_for_client!(client_id) do
    query = from s in SentrypeerEvent, where: s.client_id == ^client_id, distinct: s.source_ip
    Repo.aggregate(query, :count, :source_ip)
  end

  @doc """
  Gets the total events seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_events_for_client!(123)
      %SentrypeerEvent{}

      iex> total_events_for_client!(456)
      ** (Ecto.NoResultsError)

  """
  def total_events_for_client!(client_id) do
    query = from s in SentrypeerEvent, where: s.client_id == ^client_id
    Repo.aggregate(query, :count, :event_uuid)
  end

  @doc """
  Gets the total phone numbers seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_phone_numbers_for_client!(123)
      213

      iex> total_phone_numbers_for_client!(456)
      0

  """
  def total_unique_phone_numbers!() do
    query = from s in SentrypeerEvent, distinct: s.called_number
    Repo.aggregate(query, :count, :called_number)
  end

  @doc """
  Gets the total IP addresses seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_ip_addresses_for_client!(123)
      213

      iex> total_ip_addresses_for_client!(456)
      0

  """
  def total_unique_ip_addresses!() do
    query = from s in SentrypeerEvent, distinct: s.source_ip
    Repo.aggregate(query, :count, :source_ip)
  end

  @doc """
  Gets the total events seen from sentrypeer_events for a specific client_id.

  ## Examples

      iex> total_events_for_client!(123)
      %SentrypeerEvent{}

      iex> total_events_for_client!(456)
      ** (Ecto.NoResultsError)

  """
  def total_events!() do
    query = from(s in SentrypeerEvent)
    Repo.aggregate(query, :count, :event_uuid)
  end

  @doc """
  Creates a sentrypeer_event.

  ## Examples

      iex> create_sentrypeer_event(%{field: value})
      {:ok, %SentrypeerEvent{}}

      iex> create_sentrypeer_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sentrypeer_event(attrs \\ %{}, client_id) do
    changeset =
      %SentrypeerEvent{}
      |> SentrypeerEvent.changeset(attrs, client_id)

    if changeset.valid? do
      broadcast({:ok, changeset.changes}, client_id)

      changeset_after_insert = Repo.insert(changeset)

      # Do after insert so we have the latest data
      broadcast_all_nodes({:ok})

      changeset_after_insert
    else
      changeset
    end
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

      # Just if on Contributor plan, if so, we need to check all their clients and then only
      # return true if the phone number is in from one of their clients.
      #
      # belongs_to :client, Sentrypeer.Client, foreign_key: :client_id etc.
      # and
      #  e.client_id == ^client_id

      broadcast({:ok, phone_number}, client_id)
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

      broadcast({:ok, ip_address}, client_id)
      Repo.exists?(query)
    else
      false
    end
  end

  def subscribe(client_id) do
    Logger.debug("Subscribing to topic 'client_id:#{client_id}'")
    Phoenix.PubSub.subscribe(Sentrypeer.PubSub, "client_id:#{client_id}")
  end

  def subscribe_all_nodes() do
    Logger.debug("Subscribing to topic 'all_nodes'")
    Phoenix.PubSub.subscribe(Sentrypeer.PubSub, "all_nodes")
  end

  defp broadcast({:error, _reason} = error, _client_id), do: error

  defp broadcast({:ok, searched_for}, client_id) do
    # Logger.debug(IEx.Info.info(client_id))
    Logger.debug("Broadcasting to: 'client_id:#{client_id}'")

    Phoenix.PubSub.broadcast(
      Sentrypeer.PubSub,
      "client_id:#{client_id}",
      {searched_for, client_id}
    )

    {:ok, searched_for}
  end

  defp broadcast_all_nodes({:error, _reason} = error), do: error

  defp broadcast_all_nodes({:ok}) do
    Logger.debug("Broadcasting to: 'all_nodes'")

    Phoenix.PubSub.broadcast(
      Sentrypeer.PubSub,
      "all_nodes",
      {:ok}
    )

    {:ok}
  end
end
