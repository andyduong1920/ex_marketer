defmodule ExMarketerWeb.ViewListKeywordTest do
  use ExMarketerWeb.FeatureCase

  @path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :index)

  @messages %{
    empty_data: gettext("empty_data"),
    view_details: gettext("view_details"),
    view_page: gettext("view_page")
  }

  @selectors %{
    card_keyword: ".card-keyword",
    card_keyword_completed: ".card-keyword--completed"
  }

  describe "given the keyword in the database" do
    feature "view list keyword", %{session: session} do
      user = insert(:user)
      insert(:keyword, user: user, status: "created")
      insert(:keyword, user: user, status: "in_progress")
      insert(:keyword, user: user, status: "failed")
      insert(:keyword, user: user, status: "completed")
      insert(:keyword, user: insert(:user), keyword: "Another user keyword")

      session
      |> login(user.email, valid_user_password())
      |> visit(@path)
      |> refute_has(Query.text(@messages.empty_data))
      |> assert_has(Query.css(@selectors.card_keyword, count: 4))
      |> assert_has(Query.link(@messages.view_details))
      |> assert_has(Query.link(@messages.view_page))
      |> refute_has(Query.text("Another user keyword"))

      session
      |> find(Query.css(@selectors.card_keyword_completed))
      |> assert_has(Query.link(@messages.view_details))
      |> assert_has(Query.link(@messages.view_page))

      session
      |> click(Query.link(@messages.view_details))
      |> assert_has(Query.css(".keyword-details"))
    end
  end

  describe "given NO keyword in the database" do
    feature "view list keyword", %{session: session} do
      user = insert(:user)

      session
      |> login(user.email, valid_user_password())
      |> visit(@path)
      |> assert_has(Query.text(@messages.empty_data))
      |> refute_has(Query.css(@selectors.card_keyword))
    end
  end
end
