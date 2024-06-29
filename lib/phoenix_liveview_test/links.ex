defmodule PhoenixLiveviewTest.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias PhoenixLiveviewTest.Repo

  alias PhoenixLiveviewTest.Links.Link

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
            (like(l.url, ^search_term) or like(l.body, ^search_term))
    )
  end

  def list_links(user_id) do
    Repo.all(
      from l in Link,
        where: l.user_id == ^user_id
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
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
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
