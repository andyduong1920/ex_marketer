defmodule ExMarketer.Crawler.TaskSupervisorTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.TaskSupervisor

  describe "given a successful response" do
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/valid" do
        {:ok, pid} = TaskSupervisor.start_chilld("grammarly")

        assert is_pid(pid)
      end
    end
  end

  describe "given a list keywords" do
    test 'start_chilld/1 spawn a list new process' do
      use_cassette "google/valid_list" do
        [{:ok, pid_1}, {:ok, pid_2}] = TaskSupervisor.start_chilld(["grammarly", "developer"])

        assert is_pid(pid_1)
        assert is_pid(pid_2)
      end
    end
  end

  describe "given an unsuccesful response" do
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/invalid" do
        {:ok, pid} = TaskSupervisor.start_chilld("invalid")

        assert is_pid(pid)
      end
    end
  end
end
