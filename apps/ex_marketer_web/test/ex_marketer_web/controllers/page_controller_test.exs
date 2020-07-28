defmodule ExMarketerWeb.PageControllerTest do
  use ExMarketerWeb.ConnCase, async: true

  setup :register_and_log_in_user

  describe "given the keyword that existing in the database" do
    test "GET /pages/:existing_id", %{conn: conn} do
      successed_keyword = insert(:keyword, status: "successed")
      in_progress_keyword = insert(:keyword, status: "in_progress")
      failed_keyword = insert(:keyword, status: "failed")
      created_keyword = insert(:keyword, status: "created")

      conn_1 = get(conn, Routes.page_path(conn, :show, successed_keyword.id))
      conn_2 = get(conn, Routes.page_path(conn, :show, in_progress_keyword.id))
      conn_3 = get(conn, Routes.page_path(conn, :show, failed_keyword.id))
      conn_4 = get(conn, Routes.page_path(conn, :show, created_keyword.id))

      assert html_response(conn_1, 200) =~ "<title>ExMarketer</title>"
      assert html_response(conn_2, 404) =~ "Not Found"
      assert html_response(conn_3, 404) =~ "Not Found"
      assert html_response(conn_4, 404) =~ "Not Found"
    end
  end

  describe "given no keyword in the database" do
    test "GET /pages/:id", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :show, 22))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end
end
