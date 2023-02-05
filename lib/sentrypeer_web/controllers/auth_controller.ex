defmodule SentrypeerWeb.AuthController do
  use SentrypeerWeb, :controller
  alias Sentrypeer.Accounts.UserFromAuth

  plug Ueberauth

  def login(conn, _params) do
    conn |> redirect(to: "/auth/auth0") |> halt
  end

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(external: Application.get_env(:sentrypeer, :auth0_logout_url))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        |> redirect(to: "/dashboard")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
