defmodule PhoenixLiveviewTest.Repo.Migrations.SaveImageMetadata do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :filetype, :string
      add :filename, :string
    end
  end
end
