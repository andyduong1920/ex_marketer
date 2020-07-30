defmodule ExMarketerWeb.LayoutView do
  use ExMarketerWeb, :view

  def authentication_class(current_user) do
    if is_nil(current_user) do
      ""
    else
      "authenticated"
    end
  end

  def formatted_controller_name(controller) do
    Atom.to_string(controller)
    |> String.split(".")
    |> List.last
  end

  def formatted_action_name(action) do
    Atom.to_string(action)
  end
end
