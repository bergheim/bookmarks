defmodule PhoenixLiveviewTest.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixLiveviewTest.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        body: "some body",
        url: "some url"
      })
      |> PhoenixLiveviewTest.Links.create_link()

    link
  end
end
