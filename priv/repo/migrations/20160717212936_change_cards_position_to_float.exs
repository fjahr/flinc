defmodule Flinc.Repo.Migrations.ChangeCardsPositionToFloat do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      modify :position, :float, default: 0
    end
  end
end
