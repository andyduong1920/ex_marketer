defmodule ExMarketerWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ExMarketerWeb.Gettext
      import ExMarketerWeb.Factory

      alias ExMarketerWeb.Router.Helpers, as: Routes
    end
  end
end
