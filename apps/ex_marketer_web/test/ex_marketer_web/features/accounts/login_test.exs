defmodule ExMarketerWeb.Accounts.LoginTest do
  use ExMarketerWeb.FeatureCase, async: true

  alias ExMarketer.AccountsFactory

  feature "Login", %{session: session} do
    user = AccountsFactory.user_fixture()

    session
    |> login(user.email, AccountsFactory.valid_user_password())
    |> assert_has(Query.css(".app-layout"))
    |> assert_has(Query.text(user.email))
  end
end
