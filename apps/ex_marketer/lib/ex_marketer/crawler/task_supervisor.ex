defmodule ExMarketer.Crawler.TaskSupervisor do
  alias ExMarketer.Crawler.Worker

  def start_chilld(keywords) when is_list(keywords) do
    keywords |> Enum.map(&start_chilld(&1))
  end

  def start_chilld(keyword) when is_binary(keyword) do
    # TODO: Store the keyword into the Database and passing the record id the worker
    record_id = 1

    Task.Supervisor.start_child(
      ExMarketer.TaskSupervisor,
      fn ->
        Worker.perform(record_id, keyword)
      end,
      restart: :transient
    )
  end
end
