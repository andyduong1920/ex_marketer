defmodule ExMarketer.Crawler.Worker do
  use GenServer

  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse

  def start_link([record_id, keyword]) do
    GenServer.start_link(__MODULE__, [record_id, keyword])
  end

  def init([record_id, keyword]) do
    send(self(), :perform)

    {:ok, %{record_id: record_id, keyword: keyword}}
  end

  def handle_info(:perform, state) do
    record_id = state[:record_id]
    keyword = state[:keyword]

    on_start(record_id)

    try do
      {:ok, response_body} = Request.get(keyword)
      result = Parse.perform(response_body)

      on_complete(record_id, result)

      {:noreply, state}
    rescue
      ex ->
        on_fail(record_id, ex)

        # Re-raise the exception so the Supervisor could restart the worker
        raise ex
    end
  end

  defp on_start(record_id) do
    record_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().in_progress})
  end

  defp on_complete(record_id, result) do
    record_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().successed, result: Map.from_struct(result)})

    # TODO: Broadcast to Phoenix Channel
    :ok
  end

  defp on_fail(record_id, ex) do
    %MatchError{term: {:error, error_message}} = ex

    record_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: error_message})

    :error
  end

  defp find_keyword(record_id) do
    Keyword.find(record_id)
  end
end
