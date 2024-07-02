defmodule PhoenixLiveviewTest.Links.Image do
  use Ecto.Schema
  require Regex
  import Ecto.Changeset

  schema "images" do
    field :path, :string
    field :image, :binary

    belongs_to :link, PhoenixLiveviewTest.Links.Link

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:path, :image])
    |> validate_required([:path, :image])

    # |> unique_constraint(:path)
  end
end
