defmodule PhoenixLiveviewTest.Links.Link do
  use Ecto.Schema
  require Regex
  import Ecto.Changeset

  schema "links" do
    field :body, :string
    field :url, :string

    belongs_to :user, PhoenixLiveviewTest.Users.User
    has_one :image, PhoenixLiveviewTest.Links.Image

    timestamps(type: :utc_datetime)
  end

  defp add_protocol(changeset) do
    update_change(changeset, :url, fn url ->
      case Regex.match?(~r/^https?:\/\//, url) do
        true -> url
        false -> "https://#{url}"
      end
    end)
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:url, :body, :user_id])
    |> validate_required([:url, :user_id])
    |> validate_format(:url, ~r/.*\w\.\w/)
    |> add_protocol()
    |> unique_constraint(:url)
  end
end
