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
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("submit", %{"link" => link_params}, socket) do
    user_id = socket.assigns.current_user.id

    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        # TODO use files for this after db test is done
        # dest = Path.join([:code.priv_dir(:phoenix_liveview_test), "static", "uploads", Path.basename(path)])
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        contents = File.read!(path)
        {:ok, contents}
      end)

    link_params =
      link_params
      |> Map.put("user_id", user_id)
      |> Map.put("image", List.first(uploaded_files))

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

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:my_app), "static", "uploads", Path.basename(path)])
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp format_date(datetime) do
    datetime
    # TODO: this should use a locale..
    |> Timex.format!("{D}/{M}/{YY} {h24}:{m}")
  end

  defp strip_protocol(nil), do: nil

  defp strip_protocol(url) do
    url
    |> String.replace(~r{^https?://}, "")
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
