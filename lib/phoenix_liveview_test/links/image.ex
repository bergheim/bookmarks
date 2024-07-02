defmodule PhoenixLiveviewTest.Links.Image do
  use Ecto.Schema
  require Regex
  import Ecto.Changeset

  schema "images" do
    field :path, :string
    field :image, :binary
    field :filetype, :string
    field :filename, :string

    belongs_to :link, PhoenixLiveviewTest.Links.Link

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:path, :image, :link_id, :filetype, :filename])
    |> validate_required([:path, :image, :link_id, :filetype, :filename])

    # |> unique_constraint(:path)
  end
end
