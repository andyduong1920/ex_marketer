defmodule ExMarketerWeb.KeywordLive.KeywordComponentTest do
  use ExMarketerWeb.LiveCase

  alias ExMarketerWeb.KeywordLive.KeywordComponent

  test "is selected_keyword" do
    keyword = insert(:keyword, keyword: "Keyword title")

    html =
      render_component(
        KeywordComponent,
        id: "keyword-#{keyword.id}",
        keyword: keyword,
        recently_search: false,
        selected_keyword: keyword.id
      )

    assert html =~ "Keyword title"
    assert html =~ "card-keyword--selected"
  end

  test "is NOT selected_keyword" do
    keyword = insert(:keyword, keyword: "Keyword title")

    html =
      render_component(
        KeywordComponent,
        id: "keyword-#{keyword.id}",
        keyword: keyword,
        recently_search: false,
        selected_keyword: nil
      )

    assert html =~ "Keyword title"
    refute html =~ "card-keyword--selected"
  end

  test "is recently_search" do
    keyword = insert(:keyword, keyword: "Keyword title")

    html =
      render_component(
        KeywordComponent,
        id: "keyword-#{keyword.id}",
        keyword: keyword,
        recently_search: true,
        selected_keyword: nil
      )

    assert html =~ "Keyword title"
    assert html =~ "card-keyword--recently-search"
  end

  test "is NOT recently_search" do
    keyword = insert(:keyword, keyword: "Keyword title")

    html =
      render_component(
        KeywordComponent,
        id: "keyword-#{keyword.id}",
        keyword: keyword,
        recently_search: false,
        selected_keyword: nil
      )

    assert html =~ "Keyword title"
    refute html =~ "card-keyword--recently-search"
  end
end
