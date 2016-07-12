defmodule Flinc.AddTypeToCard do
  use Flinc.IntegrationCase

  alias Flinc.{Board}

  setup do
    user = create_user
    board = create_board(user)
    list = create_list(board)
    card = create_card(list)

    {:ok, %{user: user, board: board, list: list, card: card}}
  end

  @tag :integration
  test "Clicking on a previously created list", %{user: user, board: board, list: list, card: card} do
    user_sign_in(%{user: user, board: board})

    navigate_to "/boards/#{Board.slug_id(board)}"

    find_element(:id, "card_#{card.id}")
    |> click

    card_modal = find_element(:class, "card-modal")

    card_modal
    |> find_within_element(:id, "type-selector-button")
    |> click

    type_selector = find_element(:class, "type-selector")

    type_selector
    |> find_within_element(:id, "bug-type-selector")
    |> click

    card_modal
    |> find_within_element(:id, "close-modal")
    |> click

    assert element_displayed?({:class, "bug"})
  end
end
