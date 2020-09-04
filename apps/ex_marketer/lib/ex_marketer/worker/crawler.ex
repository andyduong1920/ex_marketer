defmodule ExMarketer.Worker.Crawler do
  use Oban.Worker, queue: :crawler, max_attempts: 2

  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Parse

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id, "keyword" => keyword}}) do
    on_start(keyword_id)

    try do
      {:ok, response_body} = google_client().get(keyword)

      on_success(keyword_id, Parse.perform(response_body))
    rescue
      ex ->
        on_fail(keyword_id)

        # Re-raise the exception so Oban could retry
        raise ex
    end

    :ok
  end

  defp google_client, do: Application.get_env(:ex_marketer, :google_client)

  defp on_start(keyword_id) do
    keyword_record = find_keyword(keyword_id)


    Keyword.update!(keyword_record, %{status: Keyword.statues().in_progress})

    broadcast_to_user(keyword_record.user_id, keyword_id)
  end

  defp on_success(keyword_id, result) do
    keyword_record = find_keyword(keyword_id)


    Keyword.update!(keyword_record, %{status: Keyword.statues().completed, result: Map.from_struct(result)})

    broadcast_to_user(keyword_record.user_id, keyword_id)

    :ok
  end

  defp on_fail(keyword_id) do
    keyword_record = find_keyword(keyword_id)


    Keyword.update!(keyword_record, %{status: Keyword.statues().failed})

    broadcast_to_user(keyword_record.user_id, keyword_id)

    :error
  end

  defp find_keyword(keyword_id) do
    Keyword.find(keyword_id)
  end

  defp broadcast_to_user(user_id, keyword_id) do
    Phoenix.PubSub.broadcast!(
      ExMarketer.PubSub,
      "user_keyword:#{user_id}",
      {:keyword_completed, %{keyword_id: keyword_id}}
    )
  end
end
