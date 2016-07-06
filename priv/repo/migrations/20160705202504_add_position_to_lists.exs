defmodule Flinc.Repo.Migrations.AddPositionToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :position, :integer, defaul: 0
    end
  end
end
