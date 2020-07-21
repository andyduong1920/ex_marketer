defmodule ExMarketerWeb.KeywordController do
  use ExMarketerWeb, :controller

  alias ExMarketer.Keyword

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
end
