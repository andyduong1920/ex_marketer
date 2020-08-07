defmodule ExMarketerWeb.FeatureCaseHound do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      import ExMarketerWeb.Gettext
      import ExMarketerWeb.Factory

      alias ExMarketerWeb.Router.Helpers, as: Routes
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ExMarketer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ExMarketer.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(ExMarketer.Repo, self())
    Hound.start_session(metadata: metadata)
    :ok
  end
end
