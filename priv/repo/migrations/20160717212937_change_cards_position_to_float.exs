defmodule Flinc.Repo.Migrations.ChangeCardsPositionToFloat do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      modify :position, :integer, default: 0
    end
  end
end
