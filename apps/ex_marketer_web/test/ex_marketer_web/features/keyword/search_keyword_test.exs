defmodule ExMarketerWeb.SearchKeywordTest do
  use ExMarketerWeb.FeatureCase

  @index_path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :index)

  @selectors %{
    search_field: "search_keyword_name",
    is_searching: ".card-keyword--recently-search"
  }
  @messages %{
    empty_data: gettext("empty_data")
  }

  describe "given the keyword in the database" do
    feature "search keyword", %{session: session} do
      user = insert(:user)
      insert(:keyword, keyword: "Developer", user: user)
      insert(:keyword, keyword: "Elixir", user: user)

      session
      |> login(user.email, valid_user_password())
      |> visit(@index_path)
      |> fill_in(Query.text_field(@selectors.search_field), with: "Elix")
      |> assert_has(Query.text("Elixir"))
      |> assert_has(Query.css(@selectors.is_searching))
      |> refute_has(Query.text(@messages.empty_data))
      |> refute_has(Query.text("Developer"))
    end
  end

  describe "given NO keyword in the database" do
    feature "search keyword", %{session: session} do
      user = insert(:user)
      insert(:keyword, keyword: "Developer", user: user)

      session
      |> login(user.email, valid_user_password())
      |> visit(@index_path)
      |> fill_in(Query.text_field(@selectors.search_field), with: "Random")
      |> assert_has(Query.text(@messages.empty_data))
    end
  end
end
