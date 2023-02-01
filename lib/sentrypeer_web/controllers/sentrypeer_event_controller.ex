defmodule SentrypeerWeb.SentrypeerEventController do
  use SentrypeerWeb, :controller

  alias Sentrypeer.SentrypeerEvents
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  action_fallback SentrypeerWeb.FallbackController

  def create(conn, sentrypeer_event_params) do
    with {:ok, %SentrypeerEvent{} = _sentrypeer_event} <-
           SentrypeerEvents.create_sentrypeer_event(sentrypeer_event_params) do
      conn
      |> put_status(:created)
      |> text("Thanks for using SentryPeer!")
    end
  end
end
