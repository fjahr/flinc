defmodule Flinc.BoardTest do
  use Flinc.ModelCase, async: true

  import Flinc.Factory

  alias Flinc.Board

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    user = insert(:user)
    attributes = @valid_attrs
      |> Map.put(:user_id, user.id)

    changeset = Board.changeset(build(:board), attributes)
    assert changeset.valid?

    %{slug: slug} = changeset.changes
    assert slug == "some-content"
  end

  test "changeset with invalid attributes" do
    changeset = Board.changeset(%Board{}, @invalid_attrs)
    refute changeset.valid?
  end
end
