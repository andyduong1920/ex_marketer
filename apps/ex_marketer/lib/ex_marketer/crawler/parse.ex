defmodule ExMarketer.Crawler.Parse do
  alias ExMarketer.Crawler.Result

  @selectors %{
    total_link: "a[href]",
    total_ads: ".ads-ad",
    non_ads: "#search .r > a",
    ads_on_top: "#tads .ads-ad .ad_cclk a.V0MxL"
  }

  def perform(document) do
    {:ok, parsed_document} = document |> Floki.parse_document()

    %Result{raw_html: document}
    |> parse_total_links(parsed_document)
    |> parse_total_ads(parsed_document)
    |> parse_non_ads_links(parsed_document)
    |> parse_ads_on_top_links(parsed_document)
  end

  defp parse_total_links(result, document) do
    total_links = document |> Floki.find(@selectors.total_link) |> Enum.count()

    %{result | total_link: total_links}
  end

  defp parse_total_ads(result, document) do
    total_ads = document |> Floki.find(@selectors.total_ads) |> Enum.count()

    %{result | total_ads: total_ads}
  end

  defp parse_non_ads_links(result, document) do
    non_ads_links = document |> Floki.find(@selectors.non_ads) |> Floki.attribute("href")

    %{result | non_ads_link: non_ads_links, total_non_ads: non_ads_links |> Enum.count()}
  end

  defp parse_ads_on_top_links(result, document) do
    ads_on_top_link = document |> Floki.find(@selectors.ads_on_top) |> Floki.attribute("href")

    %{
      result
      | ads_on_top_link: ads_on_top_link,
        total_ads_on_top: ads_on_top_link |> Enum.count()
    }
  end
end
