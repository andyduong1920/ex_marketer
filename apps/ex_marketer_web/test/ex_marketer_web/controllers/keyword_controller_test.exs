defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase, async: true

  setup :register_and_log_in_user

  describe "given the keyword that existing in the database" do
    test "GET /keywords/:id", %{conn: conn, user: user} do
      completed_keyword =
        insert(:keyword, keyword: "Example keyword", status: "completed", user: user)

      in_progress_keyword = insert(:keyword, status: "in_progress", user: user)
      failed_keyword = insert(:keyword, status: "failed", user: user)
      created_keyword = insert(:keyword, status: "created", user: user)
      another_completed_keyword = insert(:keyword, status: "completed", user: insert(:user))

      conn_1 = get(conn, Routes.keyword_path(conn, :show, completed_keyword.id))
      conn_2 = get(conn, Routes.keyword_path(conn, :show, in_progress_keyword.id))
      conn_3 = get(conn, Routes.keyword_path(conn, :show, failed_keyword.id))
      conn_4 = get(conn, Routes.keyword_path(conn, :show, created_keyword.id))
      conn_5 = get(conn, Routes.keyword_path(conn, :show, another_completed_keyword.id))

      assert html_response(conn_1, 200) =~ "Example keyword"
      assert html_response(conn_1, 200) =~ "class=\"keyword-details\""
      assert html_response(conn_2, 404) =~ "Not Found"
      assert html_response(conn_3, 404) =~ "Not Found"
      assert html_response(conn_4, 404) =~ "Not Found"
      assert html_response(conn_5, 404) =~ "Not Found"
    end
  end

  describe "given no keyword in the database" do
    test "GET /keywords/:id", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :show, 22))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert redirected_to(conn) === Routes.live_path(conn, ExMarketerWeb.KeywordLive.IndexLive)
    end
  end
end
