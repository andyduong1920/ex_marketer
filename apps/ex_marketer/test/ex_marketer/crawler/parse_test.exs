defmodule ExMarketer.Crawler.ParseTest do
  use ExUnit.Case, async: true

  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse
  alias ExMarketer.Crawler.Result

  test "perform/1 returns the ExMarketer.Crawler.Result" do
    {:ok, response_body} = Request.get("grammarly")

    assert Parse.perform(response_body) === expecting_result()
  end

  defp expecting_result do
    %Result{
      raw_html: raw_html(),
      total_ads_on_top: 1,
      total_non_ads: 10,
      total_ads: 1,
      total_link: 106,
      ads_on_top_link: ["https://www.grammarly.com/"],
      non_ads_link: [
        "https://www.grammarly.com/",
        "https://www.grammarly.com/grammar-check",
        "https://www.grammarly.com/keyboard",
        "https://chrome.google.com/webstore/detail/grammarly-for-chrome/kbfnbcaeplbcioakkpcpgfkobkghlhen",
        "https://chrome.google.com/webstore/detail/grammarly-for-chrome/kbfnbcaeplbcioakkpcpgfkobkghlhen?hl=vi",
        "https://play.google.com/store/apps/details?id=com.grammarly.android.keyboard&hl=vi",
        "https://en.wikipedia.org/wiki/Grammarly",
        "https://apps.apple.com/us/app/grammarly-keyboard/id1158877342",
        "https://www.grammarcheck.net/editor/",
        "https://quantrimang.com/cach-su-dung-grammarly-kiem-tra-tieng-anh-tren-microsoft-word-127626"
      ]
    }
  end

  defp raw_html do
    {:ok, body} = File.read("test/fixture/vcr_cassettes/google/valid.json")
    {:ok, json} = Jason.decode(body)

    result = json |> Enum.at(0)

    result["response"]["body"]
  end
end
