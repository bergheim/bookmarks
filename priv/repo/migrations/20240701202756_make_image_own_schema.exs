defmodule PhoenixLiveviewTest.Repo.Migrations.MakeImageOwnSchema do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :path, :string
      add :image, :binary
      add :link_id, references(:links, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
