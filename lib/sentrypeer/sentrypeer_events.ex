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
  def create_sentrypeer_event(attrs \\ %{}) do
    %SentrypeerEvent{}
    |> SentrypeerEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sentrypeer_event.

  ## Examples

      iex> update_sentrypeer_event(sentrypeer_event, %{field: new_value})
      {:ok, %SentrypeerEvent{}}

      iex> update_sentrypeer_event(sentrypeer_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sentrypeer_event(%SentrypeerEvent{} = sentrypeer_event, attrs) do
    sentrypeer_event
    |> SentrypeerEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sentrypeer_event.

  ## Examples

      iex> delete_sentrypeer_event(sentrypeer_event)
      {:ok, %SentrypeerEvent{}}

      iex> delete_sentrypeer_event(sentrypeer_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sentrypeer_event(%SentrypeerEvent{} = sentrypeer_event) do
    Repo.delete(sentrypeer_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sentrypeer_event changes.

  ## Examples

      iex> change_sentrypeer_event(sentrypeer_event)
      %Ecto.Changeset{data: %SentrypeerEvent{}}

  """
  def change_sentrypeer_event(%SentrypeerEvent{} = sentrypeer_event, attrs \\ %{}) do
    SentrypeerEvent.changeset(sentrypeer_event, attrs)
  end

  @doc """
  Check a phone number that has been submitted via a sentrypeer_event exists

  Returns true if exists, false if it does not

  ## Examples

      iex> check_phone_number_sentrypeer_event?("0800800800")
      true

      iex> check_phone_number_sentrypeer_event?("0800800800")
      false

  """
  def check_phone_number_sentrypeer_event?(phone_number) do
    changeset =
      SentrypeerPhoneNumber.changeset(%SentrypeerPhoneNumber{}, %{phone_number: phone_number})

    if changeset.valid? do
      query = from e in SentrypeerEvent, where: e.called_number == ^phone_number
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
  def check_ip_address_sentrypeer_event?(ip_address) do
    changeset = SentrypeerIpAddress.changeset(%SentrypeerIpAddress{}, %{ip_address: ip_address})

    if changeset.valid? do
      query = from e in SentrypeerEvent, where: e.source_ip == ^ip_address
      Repo.exists?(query)
    else
      false
    end
  end
end
