defmodule ExMarketer.Crawler.TaskSupervisorTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.TaskSupervisor

  describe "given a successful response" do
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/valid" do
        {:ok, pid} = TaskSupervisor.start_chilld("grammarly")

        assert pid !== nil
      end
    end
  end

  describe "given an unsuccesful response" do
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/invalid" do
        {:ok, pid} = TaskSupervisor.start_chilld("invalid")

        assert pid !== nil
      end
    end
  end
end
