defmodule PhoenixLiveviewTestWeb.ImageController do
  use PhoenixLiveviewTestWeb, :controller
  require IEx

  # alias PhoenixLiveviewTest.Repo
  alias PhoenixLiveviewTest.Links

  def show(conn, %{"id" => id}) do
    image_record = Links.get_link!(id)

    # IEx.pry()

    content =
      if File.exists?(image_record.image.path),
        do: File.read!(image_record.image.path),
        else: image_record.image.image

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, content)
  end
end
