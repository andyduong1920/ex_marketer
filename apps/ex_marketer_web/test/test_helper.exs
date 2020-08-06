{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)
{:ok, _} = Application.ensure_all_started(:hound)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ExMarketer.Repo, :manual)

Application.put_env(:wallaby, :base_url, ExMarketerWeb.Endpoint.url())
