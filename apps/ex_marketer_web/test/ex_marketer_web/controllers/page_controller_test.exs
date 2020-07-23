defmodule ExMarketerWeb.PageControllerTest do
  use ExMarketerWeb.ConnCase, async: true

  describe "given the keyword that existing in the database" do
    test "GET /pages/:existing_id", %{conn: conn} do
      successed_keyword = insert(:keyword, keyword: "Keyword", status: "successed")
      in_progress_keyword = insert(:keyword, keyword: "Keyword", status: "in_progress")

      conn = get(conn, Routes.page_path(conn, :show, successed_keyword.id))

      assert html_response(conn, 200) =~ "<title>ExMarketer</title>"

      conn = get(conn, Routes.page_path(conn, :show, in_progress_keyword.id))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "given no keyword in the database" do
    test "GET /pages/:id", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :show, 22))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end
end
