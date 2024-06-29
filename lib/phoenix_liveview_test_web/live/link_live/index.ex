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
      |> assign(:filter, "")

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

  @impl Phoenix.LiveView
  def handle_event("filter_links", %{"filter" => filter}, socket) do
    user_id = socket.assigns.current_user.id
    links = Links.list_links(user_id, filter)

    {:noreply, assign(socket, links: links, filter: filter)}
  end

  defp format_date(datetime) do
    datetime
    # TODO: this should use a locale..
    |> Timex.format!("{D}/{M}/{YY} {h24}:{m}")
  end
end
