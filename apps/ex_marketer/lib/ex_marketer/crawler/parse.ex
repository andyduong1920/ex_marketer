defmodule ExMarketer.Crawler.Parse do
  def new(body) do
    body |> parse_document |> filter
  end

  defp parse_document(body) do
    {:ok, parsed_document} = body |> Floki.parse_document()

    parsed_document
  end

  defp filter(parsed_document) do
    ads_on_top_links = parsed_document |> ads_on_top_links
    non_ads_links = parsed_document |> non_ads_links

    %{
      ads_on_top: ads_on_top_links |> Enum.count(),
      ads_on_top_link: ads_on_top_links,
      total_ads: parsed_document |> total_ads,
      total_non_ads: non_ads_links |> Enum.count(),
      non_ads_link: non_ads_links,
      total_link: parsed_document |> total_links
    }
  end

  defp total_links(parsed_document) do
    parsed_document
    |> Floki.find("a[href]")
    |> Enum.count()
  end

  defp total_ads(parsed_document) do
    parsed_document
    |> Floki.find(".ads-ad")
    |> Enum.count()
  end

  defp non_ads_links(parsed_document) do
    parsed_document
    |> Floki.find("#search .r")
    |> Enum.map(&(extract_non_ads_link(&1)))
  end

  defp extract_non_ads_link(link_item) do
    {"div", _, child} = link_item
    {"a", attributes, _} = child |> Enum.at(0)
    {"href", href} = attributes |> Enum.at(0)

    href
  end

  defp ads_on_top_links(parsed_document) do
    parsed_document
    |> Floki.find("#tads .ads-ad .ad_cclk")
    |> Enum.map(&(extract_top_ads_link(&1)))
  end

  defp extract_top_ads_link(link_item) do
    {"div", _, links} = link_item
    {"a", link, _} = links |> Enum.at(1)
    {"href", href} = link |> Enum.at(1)

    href
  end
end
