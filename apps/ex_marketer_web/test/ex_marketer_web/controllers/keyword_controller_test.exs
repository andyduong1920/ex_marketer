defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase

  alias ExMarketer.Repo
  alias ExMarketer.Crawler.TaskSupervisor

  setup :register_and_log_in_user

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), TaskSupervisor)
      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert redirected_to(conn) === Routes.keyword_index_path(conn, :index)
    end
  end
end
