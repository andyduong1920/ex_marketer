defmodule ExMarketer.Crawler.Result do
  defstruct raw_html: nil,
            total_ads_on_top: 0,
            total_non_ads: 0,
            total_ads: 0,
            total_link: 0,
            ads_on_top_link: [],
            non_ads_link: []
end
