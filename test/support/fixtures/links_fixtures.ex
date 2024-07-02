defmodule PhoenixLiveviewTest.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixLiveviewTest.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    user = attrs[:user] || PhoenixLiveviewTest.UsersFixtures.user_fixture()

    {:ok, link} =
      attrs
      |> Enum.into(%{
        body: "some bodyy",
        url: "some.url",
        user_id: user.id
      })
      |> PhoenixLiveviewTest.Links.create_link()

    link
  end
end
