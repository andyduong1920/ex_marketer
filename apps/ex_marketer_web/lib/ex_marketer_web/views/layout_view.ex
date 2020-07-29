defmodule ExMarketerWeb.LayoutView do
  use ExMarketerWeb, :view

  def authentication_class(current_user) do
    if is_nil(current_user) do
      ""
    else
      "authenticated"
    end
  end
end
