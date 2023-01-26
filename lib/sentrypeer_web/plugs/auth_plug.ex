defmodule SentrypeerWeb.AuthPlug do
  import Plug.Conn
  use SentrypeerWeb, :controller

  def init(options) do
    options
  end

  def call(conn, opts) do
    conn
    |> authenticate_user(opts)
  end

  def authenticate_user(conn, _opts) do
    user = get_session(conn, :current_user)

    case user do
      nil ->
        conn |> redirect(to: "/auth/auth0") |> halt()

      _ ->
        conn
        |> assign(:current_user, user)
    end
  end
end
