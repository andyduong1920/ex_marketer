defmodule ExMarketerWeb.Accounts.LoginTest do
  use ExMarketerWeb.FeatureCase

  feature "Login", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.user_session_path(ExMarketerWeb.Endpoint, :new))
    |> fill_in(Wallaby.Query.text_field("user_email"), with: user.email)
    |> fill_in(Wallaby.Query.text_field("user_password"), with: valid_user_password())
    |> click(Wallaby.Query.button("Login"))

    session
    |> assert_has(Query.css(".app-layout"))
    |> assert_has(Query.text("Welcome, " <> user.email))
  end

  @sessions 3
  feature "get notify when the other people login", %{sessions: [session_1, session_2, session_3]} do
    user_1 = insert(:user)
    user_2 = insert(:user)
    user_3 = insert(:user)

    session_1
    |> login(user_1.email, valid_user_password())

    session_2
    |> login(user_2.email, valid_user_password())

    session_3
    |> login(user_3.email, valid_user_password())

    session_1
    |> assert_has(Query.css(".notification .alert"))
    |> assert_has(Query.text(user_1.email, visible: false))
    |> assert_has(Query.text(user_2.email, visible: false))
    |> assert_has(Query.text(user_3.email, visible: false))

    session_2
    |> assert_has(Query.css(".notification .alert"))
    |> assert_has(Query.text(user_1.email, visible: false))
    |> assert_has(Query.text(user_2.email, visible: false))
    |> assert_has(Query.text(user_3.email, visible: false))

    session_3
    |> refute_has(Query.css(".notification .alert"))
    |> assert_has(Query.text(user_1.email, visible: false))
    |> assert_has(Query.text(user_2.email, visible: false))
    |> assert_has(Query.text(user_3.email, visible: false))
  end
end
