defmodule Sentrypeer.SentrypeerEvents.Query do
  import Ecto.Query
  alias Sentrypeer.SentrypeerEvents

  def base do
    SentrypeerEvents
  end

  def for_client(query \\ base(), client_id) do
    query
    |> where([e], e.client_id == ^client_id)
  end
end
