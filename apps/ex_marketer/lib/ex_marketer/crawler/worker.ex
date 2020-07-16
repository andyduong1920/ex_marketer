defmodule ExMarketer.Crawler.Worker do
  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse

  def perform(record_id, keyword) do
    on_start(record_id)

    try do
      {:ok, response_body} = Request.get(keyword)
      result = Parse.perform(response_body)

      on_complete(record_id, result)
    rescue
      ex ->
        on_fail(record_id, ex)

        # Re-raise the exception so the Supervisor could restart the worker
        raise ex
    end
  end

  defp on_start(_record_id) do
    # Update the record status to `in_progress`
  end

  defp on_complete(_record_id, _result) do
    # Update the record status to `completed` along with the result
  end

  defp on_fail(_record_id, _ex) do
    # Update the record status to `failed` along with the error message
  end
end
