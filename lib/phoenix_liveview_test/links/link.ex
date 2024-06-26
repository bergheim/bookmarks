defmodule PhoenixLiveviewTest.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :body, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :body])
    |> validate_required([:url, :body])
  end
end
