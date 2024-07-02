defmodule PhoenixLiveviewTestWeb.LinkLiveTest do
  use PhoenixLiveviewTestWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhoenixLiveviewTest.LinksFixtures
  import PhoenixLiveviewTest.UsersFixtures

  @create_attrs %{body: "some body", url: "some.url"}
  @update_attrs %{body: "some updated body", url: "some.updated.url"}
  @invalid_attrs %{body: nil, url: nil}

  defp create_link(%{user: user}) do
    link = link_fixture(%{user: user})
    %{link: link}
  end

  defp login_user(%{conn: conn}) do
    user = user_fixture()
    conn = log_in_user(conn, user)
    {:ok, conn: conn, user: user}
  end

  describe "Index" do
    setup [:login_user, :create_link]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/links")

      assert html =~ "Bookmarks"
      assert html =~ link.body
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert render(index_live) =~ "Add bookmark"

      assert index_live
             |> form("#bookmark_new_form", link: @invalid_attrs)
             |> render_submit() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bookmark_new_form", link: @create_attrs)
             |> render_submit()

      html = render(index_live)
      assert html =~ "some body"
    end

    test "deletes link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert index_live |> element("#links-#{link.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#links-#{link.id}")
    end
  end

  describe "Show" do
    setup [:login_user, :create_link]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, ~p"/links/#{link}")

      assert html =~ "URL"
      assert html =~ link.body
    end

    test "updates link within modal", %{conn: conn, link: link} do
      {:ok, show_live, _html} = live(conn, ~p"/links/#{link}")

      assert show_live |> element("a", "Change") |> render_click() =~
               "Update"

      assert_patch(show_live, ~p"/links/#{link}")

      # assert show_live
      #        |> form("#change_form", link: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#change_form", link: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/links")

      html = render(show_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated body"
    end
  end
end
