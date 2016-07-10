defmodule Flinc.UserTest do
  use Flinc.ModelCase, async: true

  alias Flinc.User

  @valid_attrs %{
    encrypted_password: "some content",
    email: "email@email.com",
    name: "some content",
    password: "123456"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
