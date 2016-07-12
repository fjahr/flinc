defmodule Flinc.Repo.Migrations.SetCardTypes do
  use Ecto.Migration

  def change do
    Flinc.Repo.update_all(Flinc.Card, set: [type: "task"])
  end
end
