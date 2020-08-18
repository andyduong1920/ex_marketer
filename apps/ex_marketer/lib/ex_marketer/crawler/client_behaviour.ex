defmodule ExMarketer.Crawler.ClientBehaviour do
  @callback get(String.t()) :: {:ok, body :: term()} | {:error, reason :: String.t()}
end
