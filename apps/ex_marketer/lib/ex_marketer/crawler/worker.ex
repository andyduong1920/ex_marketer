defmodule ExMarketer.Crawler.Worker do
  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse

  def perform(keyword_id, keyword) do
    on_start(keyword_id)

    try do
      {:ok, response_body} = Request.get(keyword)
      result = Parse.perform(response_body)

      on_complete(keyword_id, result)
    rescue
      ex ->
        on_fail(keyword_id, ex)

        # Re-raise the exception so the Supervisor could restart the worker
        raise ex
    end
  end

  defp on_start(keyword_id) do
    keyword_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().in_progress})
  end

  defp on_complete(keyword_id, result) do
    keyword_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().successed, result: Map.from_struct(result)})

    # TODO: Broadcast to Phoenix Channel
    :ok
  end

  defp on_fail(keyword_id, ex) do
    %MatchError{term: {:error, error_message}} = ex

    keyword_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: error_message})

    :error
  end

  defp find_keyword(keyword_id) do
    Keyword.find(keyword_id)
  end
end
