defmodule Flinc.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps
    end
    create index(:cards, [:list_id])

  end
end
