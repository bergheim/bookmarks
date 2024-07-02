defmodule PhoenixLiveviewTestWeb.ImageController do
  use PhoenixLiveviewTestWeb, :controller
  require IEx

  # alias PhoenixLiveviewTest.Repo
  alias PhoenixLiveviewTest.Repo
  alias PhoenixLiveviewTest.Links

  def show(conn, %{"id" => id}) do
    link =
      Links.get_link!(id)
      |> Repo.preload(:image)

    # IEx.pry()

    if link.image do
      content =
        if File.exists?(link.image.path),
          do: File.read!(link.image.path),
          else: link.image.image

      conn
      |> put_resp_content_type("image/png")
      |> send_resp(200, content)
    else
      conn |> send_resp(404, "")
    end
  end
end
