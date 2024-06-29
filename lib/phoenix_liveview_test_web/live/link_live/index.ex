defmodule PhoenixLiveviewTestWeb.LinkLive.Index do
  use PhoenixLiveviewTestWeb, :live_view
  use Timex

  alias PhoenixLiveviewTest.Links

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    changeset = Links.Link.changeset(%Links.Link{})

    socket =
      socket
      |> assign(:links, Links.list_links(user_id))
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("submit", %{"link" => link_params}, socket) do
    user_id = socket.assigns.current_user.id

    changeset =
      %Links.Link{}
      |> Links.Link.changeset(Map.put(link_params, "user_id", user_id))

    link_params =
      link_params
      |> Map.put("user_id", user_id)

    IO.inspect(changeset.data)

    link_exists =
      Links.list_links(user_id)
      |> Enum.any?(fn link -> link.url == link_params["url"] end)

    IO.inspect(link_exists)
    IO.inspect(link_params)

    case Links.create_link(link_params) do
      {:ok, link} ->
        changeset = Links.Link.changeset(%Links.Link{})

        socket =
          socket
          |> assign(:links, [link | socket.assigns.links])
          |> assign(:form, to_form(changeset))
          |> put_flash(:info, "Link added successfully")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(
            :form,
            to_form(changeset)
          )

        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("delete_link", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id
    # TODO make sure we own this link!
    link = Links.get_link!(id)

    # Assuming Links.delete_link/1 is a helper defined in your Links context
    {:ok, _} = Links.delete_link(link)

    {:noreply,
     socket
     |> put_flash(:info, "Link deleted successfully")
     |> assign(:links, Links.list_links(user_id))}
  end

  # def handle_event("validate", %{"link" => link_params}, socket) do
  #   changeset = Links.Link.changeset(%Links.Link{})
  #   IO.inspect(link_params)

  #   socket =
  #     socket
  #     |> to_form(action: :validate)
  #     |> assign(
  #       :form,
  #       to_form(changeset)
  #     )

  #   {:noreply, socket}
  # end

  defp format_date(datetime) do
    datetime
    # TODO: this should use a locale..
    |> Timex.format!("{D}/{M}/{YY} {h24}:{m}")
  end
end
