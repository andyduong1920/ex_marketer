defmodule ExMarketer.Crawler.Parse do
  alias ExMarketer.Crawler.Result

  def perform(body) do
    result = %Result{}

    {:ok, parsed_document} = body |> Floki.parse_document()

    parse_total_links(result, parsed_document)
    |> parse_total_ads(parsed_document)
    |> parse_non_ads_links(parsed_document)
    |> parse_ads_on_top_links(parsed_document)
  end

  defp parse_total_links(result, document) do
    total_links = document |> Floki.find("a[href]") |> Enum.count()

    %{result | total_link: total_links}
  end

  defp parse_total_ads(result, document) do
    total_ads = document |> Floki.find(".ads-ad") |> Enum.count()

    %{result | total_ads: total_ads}
  end

  defp parse_non_ads_links(result, document) do
    non_ads_links = document |> Floki.find("#search .r") |> Enum.map(&extract_non_ads_link(&1))

    %{result | non_ads_link: non_ads_links, total_non_ads: non_ads_links |> Enum.count()}
  end

  defp extract_non_ads_link(link_item) do
    {"div", _, child} = link_item
    {"a", attributes, _} = child |> Enum.at(0)
    {"href", href} = attributes |> Enum.at(0)

    href
  end

  defp parse_ads_on_top_links(result, document) do
    ads_on_top_link =
      document |> Floki.find("#tads .ads-ad .ad_cclk") |> Enum.map(&extract_top_ads_link(&1))

    %{
      result
      | ads_on_top_link: ads_on_top_link,
        total_ads_on_top: ads_on_top_link |> Enum.count()
    }
  end

  defp extract_top_ads_link(link_item) do
    {"div", _, links} = link_item
    {"a", link, _} = links |> Enum.at(1)
    {"href", href} = link |> Enum.at(1)

    href
  end
end
