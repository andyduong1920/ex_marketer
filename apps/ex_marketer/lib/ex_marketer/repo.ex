defmodule ExMarketer.Repo do
  use Ecto.Repo,
    otp_app: :ex_marketer,
    adapter: Ecto.Adapters.Postgres
end
