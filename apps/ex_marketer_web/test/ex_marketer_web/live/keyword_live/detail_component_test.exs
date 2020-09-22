defmodule ExMarketerWeb.KeywordLive.DetailComponentTest do
  use ExMarketerWeb.LiveCase

  alias ExMarketerWeb.KeywordLive.DetailComponent

  test "render com" do
    keyword = insert(:keyword, keyword: "Keyword title")

    html =
      render_component(
        DetailComponent,
        keyword: keyword
      )

    assert html =~ "Keyword title"
  end
end
