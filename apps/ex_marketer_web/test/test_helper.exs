{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ExMarketer.Repo, :manual)

Application.put_env(:wallaby, :base_url, ExMarketerWeb.Endpoint.url())
