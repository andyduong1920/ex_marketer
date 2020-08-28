defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.{Keyword, CsvParser}
  alias ExMarketer.Worker.Crawler

  def create(conn, %{"keyword" => keyword_params}) do
    changeset = Keyword.upload_keyword_changeset(keyword_params)

    if changeset.valid? do
      current_user = conn.assigns.current_user

      CsvParser.stream_parse(keyword_params["file"].path)
      |> Enum.map(fn keywords ->
        keywords
        |> Enum.each(fn keyword ->
          {:ok, keyword_record} = Keyword.create(%{keyword: String.trim(keyword), user_id: current_user.id})

          %{keyword_id: keyword_record.id, keyword: keyword_record.keyword}
          |> Crawler.new()
          |> Oban.insert()
        end)
      end)

      conn
      |> redirect(to: Routes.keyword_index_path(conn, :index))
      |> halt()
    else
      conn
      |> redirect(to: Routes.keyword_index_path(conn, :index))
      |> put_flash(:error, inspect(changeset.errors))
      |> halt()
    end
  end
end
