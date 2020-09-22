defmodule ExMarketer.KeywordTest do
  use ExMarketer.DataCase, async: true

  alias ExMarketer.Keyword

  test "statues/0 returns a Map statues" do
    assert Keyword.statues() === %{
             created: "created",
             in_progress: "in_progress",
             completed: "completed",
             failed: "failed"
           }
  end

  test "list_by_user/1 returns all Keyword records ordered with inserted_at DESC" do
    current_time = DateTime.utc_now()

    user_1 = insert(:user)
    keyword_1 = insert(:keyword, user: user_1, inserted_at: current_time)
    keyword_2 = insert(:keyword, user: user_1, inserted_at: DateTime.add(current_time, 3))

    user_2 = insert(:user)
    insert(:keyword, user: user_2, inserted_at: current_time)
    insert(:keyword, user: user_2, inserted_at: DateTime.add(current_time, 3))

    result = Keyword.list_by_user(user_1.id)

    assert is_list(result)
    assert result |> Enum.count() === 2
    assert (result |> Enum.at(0)).id == keyword_2.id
    assert (result |> Enum.at(1)).id == keyword_1.id
  end

  describe "given an id that exists in the database" do
    test "find/1 returns the Keyword by ID" do
      record = insert(:keyword)
      result = Keyword.find(record.id)

      assert is_struct(result)
      assert result.keyword() === "grammarly"
    end
  end

  describe "given an id that does NOT exist in the database" do
    test "find/1 returns nil" do
      assert Keyword.find(100) === nil
    end
  end

  describe "given valid attributes" do
    test "changeset/2 returns true" do
      user = insert(:user)

      assert Keyword.changeset(%Keyword{}, %{keyword: "grammarly", user_id: user.id}).valid? ===
               true
    end

    test "upload_keyword_changeset/1 returns true" do
      assert Keyword.upload_keyword_changeset(%{file: %{file_path: "file_path"}}).valid? === true
    end
  end

  describe "given invalid attributes" do
    test "changeset/2 returns false" do
      assert Keyword.changeset(%Keyword{}, %{keyword: nil}).valid? === false
    end

    test "upload_keyword_changeset/1 returns false" do
      assert Keyword.upload_keyword_changeset(%{file: nil}).valid? === false
    end
  end

  test "create/1 creates a record" do
    Keyword.create(params_with_assocs(:keyword, %{user_id: insert(:user).id}))

    assert Keyword.all() |> Enum.count() === 1
    keyword = Keyword.all() |> List.first()

    assert_enqueued(
      worker: ExMarketer.Worker.Crawler,
      args: %{keyword_id: keyword.id, keyword: keyword.keyword}
    )
  end

  test "update!/2 update the record" do
    record = insert(:keyword)
    Keyword.update!(record, %{status: "completed"})

    result = Keyword.find(record.id)

    assert result.status() === "completed"
  end

  describe "given a completed status" do
    test "completed?/1 returns true" do
      record = insert(:keyword, status: "completed")

      assert Keyword.completed?(record) === true
    end
  end

  describe "given a non-completed status" do
    test "completed?/1 returns false" do
      record = insert(:keyword, status: "in_progress")

      assert Keyword.completed?(record) === false
    end
  end
end
