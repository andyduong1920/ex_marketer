defmodule ExMarketer.KeywordTest do
  use ExMarketer.DataCase, async: true

  alias ExMarketer.Keyword

  test "statues/0 returns a Map statues" do
    assert Keyword.statues() === %{
             created: "created",
             in_progress: "in_progress",
             successed: "successed",
             failed: "failed"
           }
  end

  test "all/0 returns all Keyword records ordered with inserted_at DESC" do
    current_time = DateTime.utc_now()
    first_keyword = insert(:keyword, inserted_at: current_time)
    second_keyword = insert(:keyword, inserted_at: DateTime.add(current_time, 3))

    result = Keyword.all()

    assert is_list(result)
    assert result |> Enum.count() === 2
    assert result |> Enum.at(0) == second_keyword
    assert result |> Enum.at(1) == first_keyword
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
      assert Keyword.changeset(%Keyword{}, %{keyword: "grammarly"}).valid? === true
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
    insert(:keyword)

    assert Keyword.all() |> Enum.count() === 1
  end

  test "update!/2 update the record" do
    record = insert(:keyword)
    Keyword.update!(record, %{keyword: "developer"})

    result = Keyword.find(record.id)

    assert result.keyword() === "developer"
  end

  describe "given a successed status" do
    test "successed?/1 returns true" do
      record = insert(:keyword, status: "successed")

      assert Keyword.successed?(record) === true
    end
  end

  describe "given a non-successed status" do
    test "successed?/1 returns false" do
      record = insert(:keyword, status: "in_progress")

      assert Keyword.successed?(record) === false
    end
  end
end
