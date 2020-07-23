defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase, async: true

  describe "given the keyword that existing in the database" do
    test "GET /keywords", %{conn: conn} do
      insert(:keyword, keyword: "Keyword 1", status: "created")
      insert(:keyword, keyword: "Keyword 2", status: "in_progress")
      insert(:keyword, keyword: "Keyword 3", status: "failed")
      insert(:keyword, keyword: "Keyword 4", status: "successed")

      conn = get(conn, Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Keyword 1 - In Queue"
      assert html_response(conn, 200) =~ "Keyword 2 - In Progress"
      assert html_response(conn, 200) =~ "Keyword 3 - Failed"
      assert html_response(conn, 200) =~ "Keyword 4 - Successed"
    end

    test "GET /keywords/:id", %{conn: conn} do
      successed_keyword = insert(:keyword, keyword: "Keyword", status: "successed")
      in_progress_keyword = insert(:keyword, keyword: "Keyword", status: "in_progress")

      conn = get(conn, Routes.keyword_path(conn, :show, successed_keyword.id))

      assert html_response(conn, 200) =~ "Keyword"

      conn = get(conn, Routes.keyword_path(conn, :show, in_progress_keyword.id))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "given no keyword in the database" do
    test "GET /keywords", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Empty data"
    end

    test "GET /keywords/:id", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :show, 22))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  test "GET /keywords/new", %{conn: conn} do
    conn = get(conn, Routes.keyword_path(conn, :new))

    assert html_response(conn, 200) =~ "Upload"
  end

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert get_flash(conn, :info) === "The keys are uploaded successfully"
      assert redirected_to(conn) === Routes.keyword_path(conn, :index)
    end
  end

  describe "given invalid attribute" do
    test "POST /keywords", %{conn: conn} do
      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: nil}})

      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end
end
