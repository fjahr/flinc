defmodule Flinc.CardTest do
  use Flinc.ModelCase, async: true

  import Flinc.Factory

  alias Flinc.{Card}

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    user = create(:user)
    board = create(:board, %{user_id: user.id})
    list = create(:list, %{board_id: board.id})

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
end
