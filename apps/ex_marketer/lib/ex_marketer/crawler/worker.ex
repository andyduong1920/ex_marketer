defmodule ExMarketer.Crawler.Worker do
  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse

  def perform(keyword_id, keyword) do
    on_start(keyword_id)

    try do
      {:ok, response_body} = Request.get(keyword)
      result = Parse.perform(response_body)

      on_success(keyword_id, result)
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

  defp on_success(keyword_id, result) do
    keyword = find_keyword(keyword_id)

    keyword
    |> Keyword.update!(%{status: Keyword.statues().successed, result: Map.from_struct(result)})

    broadcast_to_user(keyword.user_id, keyword_id)

    :ok
  end

  defp on_fail(keyword_id, ex) do
    %MatchError{term: {:error, error_message}} = ex

    keyword = find_keyword(keyword_id)

    keyword
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: error_message})

    broadcast_to_user(keyword.user_id, keyword_id)

    :error
  end

  defp find_keyword(keyword_id) do
    Keyword.find(keyword_id)
  end

  defp broadcast_to_user(user_id, keyword_id) do
    ExMarketerWeb.Endpoint.broadcast!("user:#{user_id}", "keyword_completed", %{
      keyword_id: keyword_id
    })
  end
end
