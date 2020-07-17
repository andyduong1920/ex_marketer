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

  test "all/0 returns all Keyword records" do
    Keyword.create(%{keyword: "grammarly"})
    Keyword.create(%{keyword: "developer"})

    result = Keyword.all()

    assert is_list(result)
    assert result |> Enum.count() === 2
  end

  describe "given an id that exists in the database" do
    test "find/1 returns the Keyword by ID" do
      {:ok, record} = Keyword.create(%{keyword: "grammarly"})
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
  end

  describe "given invalid attributes" do
    test "changeset/2 returns false" do
      assert Keyword.changeset(%Keyword{}, %{keyword: ""}).valid? === false
    end
  end

  test "create/1 creates a record" do
    Keyword.create(%{keyword: "grammarly"})

    assert Keyword.all() |> Enum.count() === 1
  end

  test "update!/2 update the record" do
    {:ok, record} = Keyword.create(%{keyword: "grammarly"})
    Keyword.update!(record, %{keyword: "developer"})

    result = Keyword.find(record.id)

    assert result.keyword() === "developer"
  end
end
