defmodule Flinc.CardView do
  use Flinc.Web, :view

  def render("show.json", %{card: card}) do
    card
  end
end

