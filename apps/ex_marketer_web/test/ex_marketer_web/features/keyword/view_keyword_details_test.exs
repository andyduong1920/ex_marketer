defmodule ExMarketerWeb.ViewKeywordDetailsTest do
  use ExMarketerWeb.FeatureCase

  @index_path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :index)
  @show_path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :show, 2)

  @selectors %{
    keyword_details: ".keyword-details",
    is_selected: ".card-keyword--selected"
  }

  @messages %{
    view_details: gettext("view_details")
  }

  describe "given the keyword in the database" do
    feature "view keyword details", %{session: session} do
      user = insert(:user)
      insert(:keyword, keyword: "Example", user: user, status: "completed", id: 2)

      session
      |> login(user.email, valid_user_password())
      |> visit(@show_path)
      |> assert_has(Query.css(@selectors.keyword_details))
      |> assert_has(Query.text("Example", count: 2))
      |> assert_has(Query.css(@selectors.is_selected))
    end

    feature "view list keyword", %{session: session} do
      user = insert(:user)
      insert(:keyword, keyword: "Example", user: user, status: "completed")

      session
      |> login(user.email, valid_user_password())
      |> visit(@index_path)
      |> click(Query.link(@messages.view_details))
      |> assert_has(Query.text("Example", count: 2))
      |> assert_has(Query.css(@selectors.is_selected))
      |> assert_has(Query.css(".keyword-details"))
    end
  end

  describe "given NO keyword in the database" do
    feature "view keyword details", %{session: session} do
      user = insert(:user)

      session
      |> login(user.email, valid_user_password())
      |> visit(@show_path)
      |> assert_has(Query.text("Not Found"))
      |> refute_has(Query.css(@selectors.keyword_details))
    end
  end

  describe "given keyword that belongs to another user" do
    feature "view keyword details", %{session: session} do
      user = insert(:user)
      another_user = insert(:user)
      insert(:keyword, keyword: "Example", user: another_user, status: "completed", id: 2)

      session
      |> login(user.email, valid_user_password())
      |> visit(@show_path)
      |> assert_has(Query.text("Not Found"))
      |> refute_has(Query.css(@selectors.keyword_details))
    end
  end
end
