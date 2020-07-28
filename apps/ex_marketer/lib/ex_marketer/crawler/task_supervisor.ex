defmodule ExMarketer.Crawler.TaskSupervisor do
  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Worker

  def start_chilld(keywords, user_id) when is_list(keywords) do
    keywords |> Enum.map(&start_chilld(&1, user_id))
  end

  def start_chilld(keyword, user_id) when is_binary(keyword) do
    {:ok, record} = Keyword.create(%{keyword: keyword, user_id: user_id})

    Task.Supervisor.start_child(
      ExMarketer.TaskSupervisor,
      fn ->
        Worker.perform(record.id, keyword)
      end,
      restart: :transient
    )
  end
end
