defmodule Flinc.Factory do
  use ExMachina.Ecto, repo: Flinc.Repo

  alias Flinc.{User, Board, List, Card}

  def user_factory do
    %User{
      name: sequence(:name, &"Name #{&1}"),
      email: sequence(:email, &"email-#{&1}@foo.com"),
      encrypted_password: "12345678"
    }
  end

  def board_factory do
    %Board{
      name: sequence(:name, &"Name #{&1}"),
      user: build(:user)
    }
  end

  def board_with_lists_factory do
    %Board{
      name: sequence(:name, &"Name #{&1}"),
      user: build(:user),
      lists: build_list(3, :list)
    }
  end

  def list_factory do
    %List{
      name: sequence(:name, &"Name #{&1}")
    }
  end

  def card_factory do
    %Card{
      name: sequence(:name, &"Name #{&1}")
    }
  end

  def list_with_cards_factory do
    %List{
      name: sequence(:name, &"Name #{&1}"),
      board: build(:board),
      cards: build_list(5, :card)
    }
  end
end
