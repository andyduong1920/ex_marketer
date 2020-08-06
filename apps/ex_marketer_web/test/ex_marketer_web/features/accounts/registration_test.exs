defmodule ExMarketerWeb.Accounts.RegistrationTest do
  use ExMarketerWeb.FeatureCase

  @path Routes.user_registration_path(ExMarketerWeb.Endpoint, :new)

  feature "Registration", %{session: session} do
    session
    |> visit(@path)
    |> fill_in(Query.text_field("user_email"), with: "bot@example.com")
    |> fill_in(Wallaby.Query.text_field("user_password"), with: "123456")
    |> click(Wallaby.Query.button("Register"))
    |> assert_has(Query.css(".app-layout"))
    |> assert_has(Query.text("bot@example.com"))
  end
end
