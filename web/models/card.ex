defmodule Flinc.Card do
  use Flinc.Web, :model

  alias Flinc.{Repo, List, Card, Comment, CardMember}

  @derive {Poison.Encoder, only: [:id, :list_id, :name, :description, :position, :comments, :tags, :members, :type]}

  schema "cards" do
    field :name, :string
    field :description, :string
    field :position, :integer
    field :tags, {:array, :string}
    field :type, :string, default: "task"
    field :deleted_at, Ecto.DateTime

    belongs_to :list, List
    has_many :comments, Comment
    has_many :card_members, CardMember
    has_many :members, through: [:card_members, :user]

    timestamps
  end

  @required_fields ~w(name list_id)
  @optional_fields ~w(description position tags type)

  @valid_types ~w(bug feature improvement task)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> calculate_position()
    |> validate_inclusion(:type, @valid_types)
  end

  def update_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, @valid_types)
  end

  defp calculate_position(current_changeset) do
    model = current_changeset.data

    query = from(c in Card,
            select: c.position,
            where: c.list_id == ^(model.list_id),
            order_by: [desc: c.position],
            limit: 1)

    case Repo.one(query) do
      nil      -> put_change(current_changeset, :position, 1024)
      position -> put_change(current_changeset, :position, position + 1024)
    end
  end

  def preload_all(query \\ %Card{}) do
    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user

    from c in query, where: is_nil(c.deleted_at), preload: [:members, [comments: ^comments_query]]
  end

  def preload_all_with_archived(query \\ %Card{}) do
    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user

    from c in query, preload: [:members, [comments: ^comments_query]]
  end

  def get_by_user_and_board(query \\ %Card{}, card_id, user_id, board_id) do
    from c in query,
      left_join: co in assoc(c, :comments),
      left_join: cu in assoc(co, :user),
      left_join: me in assoc(c, :members),
      join: l in assoc(c, :list),
      join: b in assoc(l, :board),
      join: ub in assoc(b, :user_boards),
      where: ub.user_id == ^user_id and b.id == ^board_id and c.id == ^card_id,
      preload: [comments: {co, user: cu }, members: me]
  end

  def archive(card) do
    changeset = Ecto.Changeset.change card, deleted_at: Ecto.DateTime.utc(:sec)
    return = Repo.update(changeset)
  end

  def active(query \\ Card) do
    from c in query,
      where: is_nil(c.deleted_at)
  end
end
