defmodule PhoenixLiveviewTest.Repo.Migrations.DropImageBinaryOnLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      remove :image
    end
  end
end
