defmodule PhoenixLiveviewTest.Links.Link do
  use Ecto.Schema
  require Regex
  import Ecto.Changeset

  schema "links" do
    field :body, :string
    field :url, :string

    belongs_to :user, PhoenixLiveviewTest.Users.User

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

  defp foo(change) do
    IO.inspect(change)
    change
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:url, :body, :user_id])
    |> validate_required([:url, :user_id])
    |> validate_format(:url, ~r/.*\w\.\w/)
    |> add_protocol()

    # |> validate_format(:url, ~r/@/)
  end
end
