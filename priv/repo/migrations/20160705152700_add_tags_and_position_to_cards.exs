defmodule Flinc.Repo.Migrations.AddTagsAndPositionToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :tags, {:array, :string}, default: []
      add :position, :integer, default: 0
    end

    create index(:cards, [:tags])
  end
end
