defmodule RecomendationFrontWeb.TerritoryIndexLive do
  use RecomendationFrontWeb, :live_view
  alias RecomendationFront.Territories.UseCases.{CreateTerritory, PaginateTerritoriesForUser}
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  def mount(_params, _session, socket) do
    PubSub.subscribe_territory_created(socket.assigns.current_user.id)

    {:ok,
     socket
     |> assign(new: false)}
  end

  def handle_params(params, _uri, socket) do
    params =
      params
      |> Map.put(:user_id, socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(territories: PaginateTerritoriesForUser.execute(params))}
  end

  def handle_info(:territory_created, socket) do
    {:noreply,
     socket
     |> push_navigate(to: Routes.live_path(socket, __MODULE__))}
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    {:noreply,
     push_patch(socket,
       to: Routes.live_path(socket, __MODULE__, page: socket.assigns.territories.page_number + 1)
     )}
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    {:noreply,
     push_patch(socket,
       to: Routes.live_path(socket, __MODULE__, page: socket.assigns.territories.page_number - 1)
     )}
  end

  def handle_event("paginate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("new", _, socket) do
    {:noreply,
     socket
     |> assign(new: true)
     |> assign(changeset: CreateTerritory.new())}
  end

  def handle_event("save", %{"create_territory" => params}, socket) do
    params
    |> Map.put("owner_id", socket.assigns.current_user.id)
    |> CreateTerritory.execute()
    |> case do
      :ok ->
        {:noreply, socket |> assign(new: false)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end

  def handle_event("validate", %{"create_territory" => params}, socket) do
    changeset =
      params
      |> Map.put("owner_id", socket.assigns.current_user.id)
      |> CreateTerritory.new()

    {:noreply,
     socket
     |> assign(changeset: changeset)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, socket |> assign(new: false)}
  end

  def create_modal(assigns) do
    ~H"""
    <.modal max_width="md" title="Nova Zona de Cultivo">
       <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save">
           <.form_field
               type="text_input"
               form={f}
               field={:name}
               label={"Nome"}
           />
           <div class="mt-5">
            <%= if @changeset.valid? do %>
              <.button class="w-full rounded" type="submit" label="Adicionar" />
            <% else %>
              <.button disabled class="w-full rounded" type="submit" label="Adicionar" />
            <% end %>
           </div>
       </.form>
    </.modal>
    """
  end

  def render(assigns) do
    ~H"""
    <.container class="relative z-20 w-full">
    <div class="grid gap-4 grid-cols-4 w-full">
        <%= for t <- @territories do %>
            <.a link_type="live_redirect" to={Routes.live_path(@socket, RecomendationFrontWeb.TerritoryLive, t.uuid)}>
            <.card>
                <.card_media src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.F00dCf4bXxX0J-qEEf4qIQHaD6%26pid%3DApi&f=1&ipt=cebacfbc2aa329e900e94846bed25a70a487c7be854f270204267fea9ef9ec94&ipo=images" />
                <.card_content  class="max-w-sm" heading={t.name}> </.card_content>
            </.card>
            </.a>
        <% end %>
    </div>
    <%= if @territories.total_pages > 1 do %>
      <div class="w-full flex justify-center pt-4" phx-window-keydown="paginate">
        <.pagination link_type="live_redirect" class="mb-5" path={fn page -> Routes.live_path(@socket, __MODULE__, [page: page]) end} current_page={@territories.page_number} total_pages={@territories.total_pages} />
      </div>
    <% end %>
    <div class="fixed bottom-10 right-20">
      <.button phx-click="new" class="rounded-full z-30 p-3" color="primary" size="xl">
        <.icon name={:plus} class="w-8 h-8" />
      </.button>
    </div>

    </.container>

    <%= if @new  do %>
      <.create_modal changeset={@changeset}/>
    <% end %>
    """
  end
end
