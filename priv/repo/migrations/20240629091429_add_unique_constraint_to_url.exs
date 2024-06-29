defmodule PhoenixLiveviewTest.Repo.Migrations.AddUniqueConstraintToUrl do
  use Ecto.Migration

  def change do
    create unique_index(:links, [:url])
  end
end
