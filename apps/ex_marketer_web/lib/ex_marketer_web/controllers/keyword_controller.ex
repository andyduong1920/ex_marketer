defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.{Keyword, CsvParser}
  alias ExMarketer.Crawler.DynamicSupervisor

  def create(conn, %{"keyword" => keyword_params}) do
    changeset = Keyword.upload_keyword_changeset(keyword_params)

    if changeset.valid? do
      current_user = conn.assigns.current_user

      CsvParser.stream_parse(keyword_params["file"].path)
      |> Enum.map(&DynamicSupervisor.start_child(&1, current_user.id))

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

  def create(conn, _) do
    conn
    |> redirect(to: Routes.keyword_index_path(conn, :index))
    |> put_flash(:error, "aaa")
    |> halt()
  end
end
