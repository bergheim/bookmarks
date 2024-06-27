defmodule PhoenixLiveviewTest.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :body, :string
    field :url, :string

    belongs_to :user, PhoenixLiveviewTest.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:url, :body, :user_id])
    |> validate_required([:url, :body, :user_id])
  end
end
