defmodule ExMarketer.Crawler.GoogleClient do
  @behaviour ExMarketer.Crawler.ClientBehaviour

  @base_url "https://www.google.com/search?q="

  def get(keyword) do
    url = @base_url <> URI.encode(keyword)

    case http_adapter().get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Response code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp http_adapter, do: Application.get_env(:ex_marketer, :http_adapter)
end
