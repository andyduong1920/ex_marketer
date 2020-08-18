defmodule ExMarketerWeb.UploadKeywordTest do
  use ExMarketerWeb.FeatureCase

  import Mox

  alias ExMarketer.Crawler.GoogleClientMock

  setup :set_mox_from_context
  setup :verify_on_exit!

  @index_path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :index)

  @selectors %{
    completed_card_keyword: ".card-keyword--completed",
    keyword_file_field: "keyword_file"
  }

  feature "upload keyword", %{session: session} do
    GoogleClientMock
    |> expect(:get, 2, fn _keyword -> {:ok, "body"} end)

    user = insert(:user)

    session
    |> login(user.email, valid_user_password())
    |> visit(@index_path)
    |> attach_file(Query.file_field(@selectors.keyword_file_field),
      path: "test/fixture/template.csv"
    )
    |> click(Query.button(gettext("upload")))

    session
    |> assert_has(Query.css(@selectors.completed_card_keyword, count: 2))
    |> assert_has(Query.text("developer"))
    |> assert_has(Query.text("elixir"))
  end
end
