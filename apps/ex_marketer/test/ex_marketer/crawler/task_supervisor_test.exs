defmodule ExMarketer.Crawler.TaskSupervisorTest do
  use ExMarketer.DataCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.TaskSupervisor
  alias ExMarketer.Keyword

  describe "given a successful response" do
    @tag :skip
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/valid" do
        {:ok, pid} = TaskSupervisor.start_chilld("grammarly", user_fixture().id)

        assert is_pid(pid)
      end
    end

    @tag :skip
    test 'start_chilld/1 creates a new Keyword' do
      use_cassette "google/valid" do
        assert Keyword.all() |> Enum.count() === 0

        TaskSupervisor.start_chilld("grammarly", user_fixture().id)

        assert Keyword.all() |> Enum.count() === 1
      end
    end
  end

  describe "given a list keywords" do
    @tag :skip
    test 'start_chilld/1 spawn a list new process' do
      use_cassette "google/valid_list" do
        [{:ok, pid_1}, {:ok, pid_2}] =
          TaskSupervisor.start_chilld(["grammarly", "developer"], user_fixture().id)

        assert is_pid(pid_1)
        assert is_pid(pid_2)
      end
    end

    @tag :skip
    test 'start_chilld/1 creates a list Keyword' do
      use_cassette "google/valid_list" do
        assert Keyword.all() |> Enum.count() === 0

        TaskSupervisor.start_chilld(["grammarly", "developer"], user_fixture().id)

        assert Keyword.all() |> Enum.count() === 2
      end
    end
  end

  describe "given an unsuccesful response" do
    @tag :skip
    test 'start_chilld/1 spawn a new process' do
      use_cassette "google/invalid" do
        {:ok, pid} = TaskSupervisor.start_chilld("invalid", user_fixture().id)

        assert is_pid(pid)
      end
    end

    @tag :skip
    test 'start_chilld/1 creates a new Keyword' do
      use_cassette "google/invalid" do
        assert Keyword.all() |> Enum.count() === 0

        TaskSupervisor.start_chilld("invalid", user_fixture().id)

        assert Keyword.all() |> Enum.count() === 1
      end
    end
  end
end
