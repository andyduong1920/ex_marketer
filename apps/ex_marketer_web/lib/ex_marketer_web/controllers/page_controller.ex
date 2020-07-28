defmodule ExMarketerWeb.PageController do
  use ExMarketerWeb, :controller

  alias ExMarketer.Keyword

  def show(conn, %{"id" => id}) do
    keyword = Keyword.find(id)

    if keyword_displayable?(conn, keyword) do
      render(conn, "show.html", keyword: keyword)
    else
      render_404(conn)
    end
  end
end
