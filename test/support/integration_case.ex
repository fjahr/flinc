defmodule Flinc.IntegrationCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers
  import Flinc.Factory

  alias Flinc.{Repo, User, Board, UserBoard}

  using do
    quote do
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Flinc.Router.Helpers
      import Flinc.Factory
      import Flinc.IntegrationCase

      alias Flinc.Repo

      # The default endpoint for testing
      @endpoint Flinc.Endpoint

      hound_session
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Flinc.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Flinc.Repo, {:shared, self()})

    # tried this but did not work. In shared mode tests can not run concurrently but works for now.
    # metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Flinc.Repo, self())
    # Hound.start_session(metadata: metadata)

    :ok
  end

  def create_user do
    build(:user)
    |> User.changeset(%{password: "12345678"})
    |> Repo.insert!
  end

  def create_board(user) do
    board = user
    |> Ecto.build_assoc(:owned_boards)
    |> Board.changeset(%{name: "My new board"})
    |> Repo.insert!

    board
    |> Ecto.build_assoc(:user_boards)
    |> UserBoard.changeset(%{user_id: user.id})
    |> Repo.insert!

    board
    |> Repo.preload([:user, :members, lists: :cards])
  end

  def create_list(board) do
    board
    |> Ecto.build_assoc(:lists)
    |> Flinc.List.changeset(%{name: "First list"})
    |> Repo.insert!
  end

  def create_card(list) do
    list
    |> Ecto.build_assoc(:cards)
    |> Flinc.Card.changeset(%{name: "First card"})
    |> Repo.insert!
  end

  def user_sign_in(%{user: user}) do
    navigate_to "/"

    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:id, "user_email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:id, "user_password")
    |> fill_field(user.password)

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    assert element_displayed?({:id, "authentication_container"})
  end
end
