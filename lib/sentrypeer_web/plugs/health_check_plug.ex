defmodule SentrypeerWeb.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health-check"} = conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, '{"status": "OK"}')
    |> halt()
  end

  def call(conn, _opts), do: conn
end
