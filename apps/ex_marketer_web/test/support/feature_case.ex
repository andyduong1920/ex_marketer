defmodule ExMarketerWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ExMarketerWeb.Gettext
      import ExMarketerWeb.Factory

      alias ExMarketerWeb.Router.Helpers, as: Routes

      def login(session, email, password) do
        session
        |> visit(Routes.user_session_path(ExMarketerWeb.Endpoint, :new))
        |> fill_in(Wallaby.Query.text_field("user_email"), with: email)
        |> fill_in(Wallaby.Query.text_field("user_password"), with: password)
        |> click(Wallaby.Query.button("Login"))
      end
    end
  end
end
