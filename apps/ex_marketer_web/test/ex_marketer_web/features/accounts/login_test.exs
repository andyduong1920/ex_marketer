defmodule ExMarketerWeb.Accounts.LoginTest do
  use ExMarketerWeb.FeatureCase, async: true

  feature "Login", %{session: session} do
    user = insert(:user)

    session
    |> login(user.email, valid_user_password())
    |> assert_has(Query.css(".app-layout"))
    |> assert_has(Query.text(user.email))
  end
end
