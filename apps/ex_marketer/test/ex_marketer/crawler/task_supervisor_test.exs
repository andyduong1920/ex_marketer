defmodule ExMarketer.Crawler.TaskSupervisorTest do
  use ExMarketer.DataCase, async: true

  alias ExMarketer.Crawler.TaskSupervisor
  alias ExMarketer.Keyword

  describe "given a successful response" do
    @tag :skip
    test 'start_chilld/1 spawn a new process' do
      {:ok, pid} = TaskSupervisor.start_chilld("grammarly", insert(:user).id)

      assert is_pid(pid)
    end

    @tag :skip
    test 'start_chilld/1 creates a new Keyword' do
      assert Keyword.all() |> Enum.count() === 0

      TaskSupervisor.start_chilld("grammarly", insert(:user).id)

      assert Keyword.all() |> Enum.count() === 1
    end
  end

  describe "given a list keywords" do
    @tag :skip
    test 'start_chilld/1 spawn a list new process' do
      [{:ok, pid_1}, {:ok, pid_2}] =
        TaskSupervisor.start_chilld(["grammarly", "developer"], insert(:user).id)

      assert is_pid(pid_1)
      assert is_pid(pid_2)
    end

    @tag :skip
    test 'start_chilld/1 creates a list Keyword' do
      assert Keyword.all() |> Enum.count() === 0

      TaskSupervisor.start_chilld(["grammarly", "developer"], insert(:user).id)

      assert Keyword.all() |> Enum.count() === 2
    end
  end

  describe "given an unsuccesful response" do
    @tag :skip
    test 'start_chilld/1 spawn a new process' do
      {:ok, pid} = TaskSupervisor.start_chilld("invalid", insert(:user).id)

      assert is_pid(pid)
    end

    @tag :skip
    test 'start_chilld/1 creates a new Keyword' do
      assert Keyword.all() |> Enum.count() === 0

      TaskSupervisor.start_chilld("invalid", insert(:user).id)

      assert Keyword.all() |> Enum.count() === 1
    end
  end
end
