defmodule ExMarketer.Crawler.WorkerTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.Worker

  describe "given a successful response" do
    test 'perform/2 returns :ok' do
      use_cassette "google/valid" do
        assert Worker.perform(1, "grammarly") === :ok
      end
    end
  end

  describe "given an unsuccesful response" do
    test 'perform/2 raises an error' do
      use_cassette "google/invalid" do
        assert_raise MatchError,
                     "no match of right hand side value: {:error, \"Response code: 401\"}",
                     fn ->
                       Worker.perform(1, "invalid")
                     end
      end
    end
  end
end
