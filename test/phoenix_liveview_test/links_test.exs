defmodule PhoenixLiveviewTest.LinksTest do
  use PhoenixLiveviewTest.DataCase

  alias PhoenixLiveviewTest.Links

  describe "links" do
    alias PhoenixLiveviewTest.Links.Link

    import PhoenixLiveviewTest.LinksFixtures

    @invalid_attrs %{body: nil, url: nil}

    test "list_links/0 returns all links" do
      user = PhoenixLiveviewTest.UsersFixtures.user_fixture()
      link = link_fixture(user.id)
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      user_fixture = PhoenixLiveviewTest.UsersFixtures.user_fixture()
      valid_attrs = %{body: "some body", url: "some.url", user_id: user_fixture.id}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.body == "some body"
      assert link.url == "https://some.url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{body: "some updated body", url: "some.updated.url"}

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.body == "some updated body"
      assert link.url == "https://some.updated.url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
