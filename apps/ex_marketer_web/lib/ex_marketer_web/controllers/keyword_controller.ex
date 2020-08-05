defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.{Keyword, CsvParser}
  alias ExMarketer.Crawler.TaskSupervisor

  def create(conn, %{"keyword" => keyword_params}) do
    changeset = Keyword.upload_keyword_changeset(keyword_params)

    if changeset.valid? do
      current_user = conn.assigns.current_user

      CsvParser.stream_parse(keyword_params["file"].path)
      |> Enum.map(&TaskSupervisor.start_chilld(&1, current_user.id))

      conn
      |> redirect(to: Routes.keyword_index_path(conn, :index))
      |> halt()
    else
      render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end
end
