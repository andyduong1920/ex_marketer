defmodule ExMarketer.Crawler.DynamicSupervisor do
  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Worker

  def start_child(keywords, user_id) when is_list(keywords) do
    Task.start(fn ->
      keywords |> Enum.map(&start_child(&1, user_id))
    end)
  end

  def start_child(keyword, user_id) when is_binary(keyword) do
    :poolboy.transaction(:crawler_worker_pool, fn _pid ->
      {:ok, keyword_record} = Keyword.create(%{keyword: keyword, user_id: user_id})

      DynamicSupervisor.start_child(
        ExMarketer.DynamicSupervisor,
        Worker.child_spec(keyword_record.id)
      )
    end)
  end
end
