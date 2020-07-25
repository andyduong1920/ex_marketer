defmodule ExMarketerWeb.ViewListKeywordTest do
  use ExMarketerWeb.FeatureCase, async: true

  @path Routes.keyword_path(ExMarketerWeb.Endpoint, :index)

  @messages %{
    upload_csv: gettext("upload_csv"),
    empty_data: gettext("empty_data"),
    view_details: gettext("view_details"),
    view_page: gettext("view_page")
  }

  @selectors %{
    card_keyword: ".card-keyword",
    card_keyword_successed: ".card-keyword--successed"
  }

  describe "given the keyword in the database" do
    feature "view list keyword", %{session: session} do
      insert(:keyword, status: "created")
      insert(:keyword, status: "in_progress")
      insert(:keyword, status: "failed")
      insert(:keyword, status: "successed")

      session
      |> visit(@path)
      |> assert_has(Query.link(@messages.upload_csv))
      |> refute_has(Query.text(@messages.empty_data))
      |> assert_has(Query.css(@selectors.card_keyword, count: 4))
      |> assert_has(Query.link(@messages.view_details))
      |> assert_has(Query.link(@messages.view_page))

      session
      |> find(Query.css(@selectors.card_keyword_successed))
      |> assert_has(Query.link(@messages.view_details))
      |> assert_has(Query.link(@messages.view_page))
    end
  end

  describe "given NO keyword in the database" do
    feature "view list keyword", %{session: session} do
      session
      |> visit(@path)
      |> assert_has(Query.link(@messages.upload_csv))
      |> assert_has(Query.text(@messages.empty_data))
      |> refute_has(Query.css(@selectors.card_keyword))
    end
  end
end
