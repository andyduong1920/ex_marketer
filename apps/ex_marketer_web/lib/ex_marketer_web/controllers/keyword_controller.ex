defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.Keyword
  alias ExMarketer.CsvParser
  alias ExMarketer.Crawler.TaskSupervisor

  def show(conn, %{"id" => id}) do
    keyword = Keyword.find(id)

    if keyword_displayable?(conn, keyword) do
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
      current_user = conn.assigns.current_user

      CsvParser.stream_parse(keyword_params["file"].path)
      |> Enum.map(&TaskSupervisor.start_chilld(&1, current_user.id))

      conn
      |> put_flash(:info, gettext("upload_success"))
      |> redirect(to: Routes.live_path(conn, ExMarketerWeb.KeywordLive.IndexLive))
      |> halt()
    else
      render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end
end
