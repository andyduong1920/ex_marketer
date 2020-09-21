defmodule ExMarketerWeb.KeywordLive.IndexLiveTest do
  use ExMarketerWeb.LiveCase

  setup :register_and_log_in_user

  describe "mount" do
    test "has keywords", %{conn: conn, user: user} do
      insert(:keyword, user: user, keyword: "Keyword 1")
      insert(:keyword, user: user, keyword: "Keyword 2")

      {:ok, _view, html} = live(conn, "/keywords")

      refute html =~ "Empty data"
      assert html =~ "Keyword 1"
      assert html =~ "Keyword 2"
    end

    test "no keyword", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/keywords")

      assert html =~ "Empty data"
    end
  end

  test "form search", %{conn: conn, user: user} do
    insert(:keyword, user: user, keyword: "Keyword 1")
    insert(:keyword, user: user, keyword: "Keyword 2")

    {:ok, view, _html} = live(conn, "/keywords")

    assert render_submit(view, :form_search, %{"search" => %{"keyword_name" => "Keyword 2"}}) =~
             "Keyword 2"

    refute render_submit(view, :form_search, %{"search" => %{"keyword_name" => "Keyword 2"}}) =~
             "Keyword 1"
  end

  describe "handle params" do
    test "valid id", %{conn: conn, user: user} do
      keyword = insert(:keyword, user: user, status: "completed", keyword: "Keyword")

      {:ok, _view, html} = live(conn, "/keywords/#{keyword.id}")

      assert html =~ "keyword-details"
    end

    test "invalid id", %{conn: conn, user: user} do
      keyword = insert(:keyword, user: user, status: "in_progress", keyword: "Keyword")

      assert live(conn, "/keywords/#{keyword.id}") |> follow_redirect(conn, "/keywords")
    end
  end

  test "handle keyword complete", %{conn: conn, user: user} do
    keyword = insert(:keyword, user: user, status: "in_progress", keyword: "Keyword")

    {:ok, view, html} = live(conn, "/keywords")

    assert html =~ "In Progress: 1"

    ExMarketer.Keyword.update!(keyword, %{status: "completed"})
    send(view.pid, {:keyword_completed, %{keyword_id: keyword.id}})

    assert render(view) =~ "In Progress: 0"
  end
end
