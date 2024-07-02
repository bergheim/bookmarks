defmodule PhoenixLiveviewTestWeb.ImageController do
  use PhoenixLiveviewTestWeb, :controller

  # alias PhoenixLiveviewTest.Repo
  alias PhoenixLiveviewTest.Links

  def show(conn, %{"id" => id}) do
    image_record = Links.get_link!(id)

    send_resp(conn, 200, image_record.image)
    |> put_resp_content_type("image/png")
  end
end
