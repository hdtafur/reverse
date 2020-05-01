defmodule Reverse.Repo do
  use Ecto.Repo,
    otp_app: :reverse,
    adapter: Ecto.Adapters.Postgres
end
