defmodule PhoenixLiveviewTestWeb.LinkLive.Index do
  use PhoenixLiveviewTestWeb, :live_view

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
    params =
      link_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    IO.inspect(params)

    case Links.create_link(params) do
      {:ok, link} ->
        socket =
          socket
          |> assign(:links, [link | socket.assigns.links])

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
end
