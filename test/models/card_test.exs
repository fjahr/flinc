defmodule Flinc.CardTest do
  use Flinc.ModelCase, async: true

  import Flinc.Factory

  alias Flinc.{Card}

  @valid_attrs %{name: "some content", tags: []}
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    board = insert(:board, user: user)
    list = insert(:list, board: board)

    {:ok, list: list}
  end

  test "changeset with valid attributes", %{list: list} do
    changeset = Card.changeset(%Card{list_id: list.id}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{list: list} do
    changeset = Card.changeset(%Card{list_id: list.id}, @invalid_attrs)

    refute changeset.valid?
  end

  test "default type is set", %{list: list} do
    card = Card.changeset(%Card{list_id: list.id}, @valid_attrs)
           |> Repo.insert!

    assert card.type == "task"
  end

  test "invalid type is not allowed", %{list: list} do
    changeset = Card.changeset(%Card{list_id: list.id, name: "name"}, %{type: "not allowed"})

    refute changeset.valid?
    assert changeset.errors[:type] == {"is invalid", []}
  end

  test "existing cards for the same list", %{list: list} do
    count = 3

    for i <- 1..(count-1) do
      list
      |> build_assoc(:cards)
      |> Card.changeset(%{name: "Card #{i}"})
      |> Repo.insert
    end

    {:ok, last_card} = list
      |> build_assoc(:cards)
      |> Card.changeset(%{name: "Last"})
      |> Repo.insert

    assert last_card.position == 1024 * count
  end

  test "card position is not an integer", %{list: list} do
   card = Card.changeset(%Card{list_id: list.id}, @valid_attrs)
           |> Repo.insert!

   Card.update_changeset(card, %{position: 1.5})
   |> Repo.update

    assert card.position == 1024
  end

  test "archived cards are not returned by default scope", %{list: list} do
    card = Card.changeset(%Card{list_id: list.id}, @valid_attrs)
           |> Repo.insert!

    cards = Repo.all(Card.active)
    assert Enum.member?(cards, card)

    Card.archive(card)
    archived_card = Repo.get(Card, card.id)

    cards = Repo.all(Card.active)
    refute Enum.member?(cards, archived_card)
    assert cards == []
  end
end
