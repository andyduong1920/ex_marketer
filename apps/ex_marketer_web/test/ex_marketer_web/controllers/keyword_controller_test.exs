defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase

  setup :register_and_log_in_user

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert ExMarketer.Keyword.list_by_user(conn.assigns.current_user.id) |> Enum.count() === 2
      assert redirected_to(conn) === Routes.keyword_index_path(conn, :index)
      assert get_flash(conn, :error) === nil
    end
  end

  describe "given invalid attribute" do
    test "POST /keywords", %{conn: conn} do
      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: nil}})

      assert redirected_to(conn) === Routes.keyword_index_path(conn, :index)
      assert get_flash(conn, :error) !== nil
    end
  end
end
