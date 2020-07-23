defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.Keyword
  alias ExMarketer.CsvParser
  alias ExMarketer.Crawler.TaskSupervisor

  def index(conn, _params) do
    keywords = Keyword.all()

    render(conn, "index.html", keywords: keywords)
  end

  def show(conn, %{"id" => id}) do
    keyword = Keyword.find(id)

    if !is_nil(keyword) && Keyword.successed?(keyword) do
      render(conn, "show.html", keyword: keyword)
    else
      render_404(conn)
    end
  end

  def new(conn, _params) do
    changeset = Keyword.upload_keyword_changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"keyword" => keyword_params}) do
    changeset = Keyword.upload_keyword_changeset(keyword_params)

    if changeset.valid? do
      CsvParser.stream_parse(keyword_params["file"].path)
      |> Enum.map(&TaskSupervisor.start_chilld(&1))

      conn
      |> put_flash(:info, gettext("upload_success"))
      |> redirect(to: Routes.keyword_path(conn, :index))
      |> halt()
    else
      render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end
end
