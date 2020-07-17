defmodule ExMarketer.Crawler.WorkerTest do
  use ExMarketer.DataCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.Worker
  alias ExMarketer.Keyword

  describe "given a successful response" do
    test 'perform/2 returns :ok' do
      use_cassette "google/valid" do
        {:ok, record} = Keyword.create(%{keyword: "grammarly"})

        assert Worker.perform(record.id, "grammarly") === :ok
      end
    end

    test 'perform/2 updates the Keyword to success' do
      use_cassette "google/valid" do
        {:ok, record} = Keyword.create(%{keyword: "grammarly"})

        assert record.status === Keyword.statues().created

        Worker.perform(record.id, "grammarly")
        record = Keyword.find(record.id)

        assert record.status === Keyword.statues().successed
        assert record.result !== nil
      end
    end
  end

  describe "given an unsuccesful response" do
    test 'perform/2 raises an error' do
      use_cassette "google/invalid" do
        {:ok, record} = Keyword.create(%{keyword: "invalid"})

        assert_raise MatchError,
                     "no match of right hand side value: {:error, \"Response code: 401\"}",
                     fn ->
                       Worker.perform(record.id, "invalid")
                     end
      end
    end

    test 'perform/2 updates the Keyword to failed' do
      use_cassette "google/invalid" do
        {:ok, record} = Keyword.create(%{keyword: "invalid"})

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
end
