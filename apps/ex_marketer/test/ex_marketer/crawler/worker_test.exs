defmodule ExMarketer.Crawler.WorkerTest do
  use ExMarketer.DataCase, async: true

  import Mox

  alias ExMarketer.Crawler.Worker
  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.GoogleClientMock

  setup :verify_on_exit!

  describe "given a successful response" do
    test 'perform/2 returns :ok' do
      GoogleClientMock |> expect(:get, fn _keyword -> {:ok, "body"} end)

      record = insert(:keyword)

      assert Worker.perform(record.id, "grammarly") === :ok
    end

    test 'perform/2 updates the Keyword to success' do
      GoogleClientMock |> expect(:get, fn _keyword -> {:ok, "body"} end)

      record = insert(:keyword)

      assert record.status === Keyword.statues().created

      Worker.perform(record.id, "grammarly")
      record = Keyword.find(record.id)

      assert record.status === Keyword.statues().completed
      assert record.result !== nil
    end
  end

  describe "given an unsuccesful response" do
    test 'perform/2 raises an error' do
      ExMarketer.Crawler.GoogleClientMock
      |> expect(:get, fn _keyword -> {:error, "Response code: 401"} end)

      record = insert(:keyword, %{keyword: "invalid"})

      assert_raise MatchError,
                   "no match of right hand side value: {:error, \"Response code: 401\"}",
                   fn ->
                     Worker.perform(record.id, "invalid")
                   end
    end

    test 'perform/2 updates the Keyword to failed' do
      ExMarketer.Crawler.GoogleClientMock
      |> expect(:get, fn _keyword -> {:error, "Response code: 401"} end)

      record = insert(:keyword, %{keyword: "invalid"})

      assert record.status === Keyword.statues().created

      assert_raise MatchError,
                   "no match of right hand side value: {:error, \"Response code: 401\"}",
                   fn ->
                     Worker.perform(record.id, "invalid")
                   end

      record = Keyword.find(record.id)

      assert record.status === Keyword.statues().failed
      assert record.result === %{}
      assert record.failure_reason === "Response code: 401"
    end
  end
end
