defmodule ExMarketerWeb.KeywordView do
  use ExMarketerWeb, :view

  alias ExMarketer.Keyword

  def successed?(keyword) do
    Keyword.successed?(keyword)
  end

  def display_fail_reason?(status) do
    status === "failed"
  end

  def localize_status(status) do
    Gettext.gettext(ExMarketerWeb.Gettext, status)
  end

  def localize_result(key) do
    Gettext.gettext(ExMarketerWeb.Gettext, key)
  end
end
