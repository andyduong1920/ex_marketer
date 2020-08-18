defmodule ExMarketerWeb.UploadKeywordTest do
  use ExMarketerWeb.FeatureCase, async: true

  @path Routes.keyword_path(ExMarketerWeb.Endpoint, :new)

  @selectors %{
    card_keyword: ".card-keyword",
    keyword_file_field: "keyword_file"
  }

  feature "upload keyword", %{session: session} do
    user = insert(:user)

    session
    |> login(user.email, valid_user_password())
    |> visit(@path)
    |> attach_file(Query.file_field(@selectors.keyword_file_field),
      path: "test/fixture/template.csv"
    )
    |> click(Query.button(gettext("upload")))
    |> assert_has(Query.css(@selectors.card_keyword, count: 2))
    |> assert_has(Query.text("developer"))
    |> assert_has(Query.text("elixir"))
    |> assert_has(Query.text(gettext("upload_success")))
  end
end
