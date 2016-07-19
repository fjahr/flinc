defmodule Flinc.Repo.Migrations.AddDeletedAtToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :deleted_at, :datetime
    end
  end
end
