defmodule Flinc.User do
  use Flinc.Web, :model

  alias Flinc.{Board, UserBoard}

  @derive {Poison.Encoder, only: [:id, :name, :email]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    has_many :owned_boards, Board
    has_many :user_boards, UserBoard
    has_many :boards, through: [:user_boards, :board]

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w(encrypted_password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:email, message: "Email already taken")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
