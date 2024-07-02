defmodule PhoenixLiveviewTest.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias PhoenixLiveviewTest.Repo

  alias PhoenixLiveviewTest.Links.{Image, Link}

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """

  # def list_links do
  #   Repo.all(Link)
  # end

  def list_links(user_id, search) do
    search_term = "%#{search}%"

    Repo.all(
      from l in Link,
        # ilike is not supported by sqlite3
        # TODO: switch to ilike if we are on other dbs
        where:
          l.user_id == ^user_id and
            (like(l.url, ^search_term) or like(l.body, ^search_term)),
        order_by: [desc: l.inserted_at],
        preload: [:image]
    )
  end

  def list_links(user_id) do
    Repo.all(
      from l in Link,
        where: l.user_id == ^user_id,
        order_by: [desc: l.inserted_at],
        preload: [:image]
    )
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_link!(id), do: Repo.get!(Link, id, preload: [:image])

  def get_link!(id) do
    Link
    |> Repo.get!(id)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:link, Link.changeset(%Link{}, attrs))
    |> Ecto.Multi.run(:image, fn repo, %{link: link} ->
      if attrs["image"] do
        %Image{}
        |> Image.changeset(%{
          "link_id" => link.id,
          "path" => attrs["image"]["path"],
          "image" => attrs["image"]["image"],
          "filetype" => attrs["image"]["filetype"],
          "filename" => attrs["image"]["filename"]
        })
        |> repo.insert()
      else
        {:ok, nil}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{link: link}} -> {:ok, link}
      {:error, _operation, reason, _changes} -> {:error, reason}
    end
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
