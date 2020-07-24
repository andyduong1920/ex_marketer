defmodule ExMarketerWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ExMarketerWeb.Gettext
      import ExMarketerWeb.Factory
    end
  end
end
