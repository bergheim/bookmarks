defmodule PhoenixLiveviewTest.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixLiveviewTest.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    user_fixture = PhoenixLiveviewTest.UsersFixtures.user_fixture()

    {:ok, link} =
      attrs
      |> Enum.into(%{
        body: "some body",
        url: "some.url",
        user_id: user_fixture.id
      })
      |> PhoenixLiveviewTest.Links.create_link()

    link
  end
end
