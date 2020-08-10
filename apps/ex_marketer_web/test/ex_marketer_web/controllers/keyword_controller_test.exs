defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase

  import Mox

  alias ExMarketer.Crawler.GoogleClientMock

  setup :register_and_log_in_user
  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      parent = self()
      ref = make_ref()

      GoogleClientMock
      |> expect(:get, 2, fn keyword ->
        send(parent, {ref, "process_#{keyword}"})

        {:ok, "body"}
      end)

      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert_receive {^ref, "process_elixir"}
      assert_receive {^ref, "process_developer"}

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
