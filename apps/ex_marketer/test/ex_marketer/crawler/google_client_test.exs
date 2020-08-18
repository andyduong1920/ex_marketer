defmodule ExMarketer.Crawler.GoogleClientTest do
  use ExUnit.Case, async: true

  alias ExMarketer.Crawler.GoogleClient
  alias ExMarketer.Crawler.HttpAdapterMock

  import Mox

  setup :verify_on_exit!

  describe "given a successful response" do
    test "get/1 returns a success tuple" do
      HttpAdapterMock
      |> expect(:get, fn _url -> {:ok, %HTTPoison.Response{status_code: 200, body: "Body"}} end)

      {:ok, response_body} = GoogleClient.get("grammarly")

      assert response_body !== nil
    end
  end

  describe "given an unsuccesful response" do
    test "get/1 returns a error tuple" do
      HttpAdapterMock
      |> expect(:get, fn _url -> {:ok, %HTTPoison.Response{status_code: 401, body: "Invalid"}} end)

      {:error, error_message} = GoogleClient.get("invalid")

      assert error_message === "Response code: 401"
    end
  end

  describe "given a HTTPoison.Error" do
    test "get/1 returns a error tuple" do
      HttpAdapterMock
      |> expect(:get, fn _url -> {:error, %HTTPoison.Error{reason: "Mock error"}} end)

      {:error, error_message} = GoogleClient.get("invalid")

      assert error_message === "Mock error"
    end
  end
end
