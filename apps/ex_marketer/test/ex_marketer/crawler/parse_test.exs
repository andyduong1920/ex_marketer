defmodule ExMarketer.Crawler.ParseTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExMarketer.Crawler.Request
  alias ExMarketer.Crawler.Parse

  test "get/1 returns a success tuple" do
    use_cassette "google/valid" do
      {:ok, response_body} = Request.get("chay quang cao")

      expecting_result = %{
        ads_on_top: 4,
        ads_on_top_link: [
          "https://ads.google.com/intl/vi_vn/getstarted/",
          "https://doitacgoogle.com/",
          "https://quangcaogoogleuytin.com/",
          "https://one.adsplus.vn/"
        ],
        non_ads_link: [
          "https://thanhthinhbui.com/cach-chay-quang-cao-tren-facebook-hieu-qua/",
          "https://www.sapo.vn/blog/huong-dan-chi-tiet-cach-tao-quang-cao-facebook-hieu-qua/",
          "https://www.facebook.com/groups/399124403873008/",
          "https://moavietnam.com/lam-the-nao-de-quang-cao-tren-facebook-hieu-qua",
          "http://caohuymanh.com/internet-marketing/facebook-marketing/huong-dan-chay-quang-cao-facebook-tu-a-z.html",
          "https://kiemtiencenter.com/tao-tai-khoan-quang-cao-facebook-ads/",
          "https://seotot.vn/chay-quang-cao-facebook.html"
        ],
        total_ads: 7,
        total_link: 143,
        total_non_ads: 7
      }

      assert Parse.perform(response_body) === expecting_result
    end
  end
end
