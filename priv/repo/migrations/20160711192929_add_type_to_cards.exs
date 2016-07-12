defmodule Flinc.Repo.Migrations.AddTypeToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :type, :string
    end

    Flinc.Repo.update_all(Flinc.Card, set: [type: "task"])
  end
end
