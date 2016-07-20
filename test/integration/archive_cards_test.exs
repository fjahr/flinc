defmodule Flinc.ArchiveCardsTest do
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
  test "Cards can be archived by clicking on a button", %{user: user, board: board, list: _list, card: card} do
    user_sign_in(%{user: user, board: board})

    navigate_to "/boards/#{Board.slug_id(board)}"

    find_element(:id, "card_#{card.id}")
    |> click

    find_element(:class, "card-modal")
    |> find_within_element(:id, "archive-button")
    |> click

    {result, _message} = search_element(:id, "card_#{card.id}", 1)
    assert result == :error
  end
end
