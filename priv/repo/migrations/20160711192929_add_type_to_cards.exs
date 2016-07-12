defmodule Flinc.Repo.Migrations.AddTypeToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :type, :string
    end
  end
end
