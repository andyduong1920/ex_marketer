defmodule ExMarketerWeb.UploadKeywordTest do
  use ExMarketerWeb.FeatureCase

  @index_path Routes.keyword_index_path(ExMarketerWeb.Endpoint, :index)

  @selectors %{
    card_keyword: ".card-keyword",
    keyword_file_field: "keyword_file"
  }

  feature "upload keyword", %{session: session} do
    user = insert(:user)

    session
    |> login(user.email, valid_user_password())
    |> visit(@index_path)
    |> attach_file(Query.file_field(@selectors.keyword_file_field),
      path: "test/fixture/template.csv"
    )
    |> click(Query.button(gettext("upload")))

    session
    |> assert_has(Query.css(@selectors.card_keyword, count: 2))
    |> assert_has(Query.text("developer"))
    |> assert_has(Query.text("elixir"))
  end
end
