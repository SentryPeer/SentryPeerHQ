defmodule Sentrypeer.Repo do
  use Ecto.Repo,
    otp_app: :sentrypeer,
    adapter: Ecto.Adapters.Postgres
end
