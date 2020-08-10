defmodule ExMarketer.Crawler.RequestTest do
  use ExUnit.Case, async: true

  alias ExMarketer.Crawler.Request

  describe "given a successful response" do
    test "get/1 returns a success tuple" do
      {:ok, response_body} = Request.get("grammarly")

      assert response_body !== nil
    end
  end

  describe "given an unsuccesful response" do
    test "get/1 returns a error tuple" do
      {:error, error_message} = Request.get("invalid")

      assert error_message === "Response code: 401"
    end
  end
end
