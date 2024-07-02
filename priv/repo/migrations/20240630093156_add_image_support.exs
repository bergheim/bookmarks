defmodule PhoenixLiveviewTest.Repo.Migrations.AddImageSupport do
  use Ecto.Migration

  def change do
    # add a new field, image, to the database
    alter table(:links) do
      add :image, :binary
    end
  end
end
