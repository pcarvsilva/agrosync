defmodule RecomendationFrontWeb.SpiciesIndexLive do
  use RecomendationFrontWeb, :live_view
  alias RecomendationFront.Spicies.Domain.Entities.{Stage, Stratum}
  alias RecomendationFront.Spicies.UseCases.{GetPaginatedSpicies, GetSpicie, AddAgroFlorestryData}

  def handle_params(params, _uri, socket) do
    params =
      params
      |> Map.put(:user_id, socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(species: GetPaginatedSpicies.execute(params))
     |> assign(search: params["search"])
     |> assign(selected: nil)}
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    {:noreply,
     push_patch(socket,
       to:
         Routes.live_path(socket, __MODULE__,
           page: socket.assigns.species.page_number + 1,
           search: socket.assigns.search
         )
     )}
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    {:noreply,
     push_patch(socket,
       to:
         Routes.live_path(socket, __MODULE__,
           page: socket.assigns.species.page_number - 1,
           search: socket.assigns.search
         )
     )}
  end

  def handle_event("paginate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("search", %{"search_spicie" => %{"name" => search}}, socket) do
    {:noreply, socket |> assign(search: search)}
  end

  def handle_event("send", %{"search_spicie" => %{"name" => search}}, socket) do
    {:noreply,
     push_patch(socket,
       to:
         Routes.live_path(socket, __MODULE__,
           page: socket.assigns.species.page_number,
           search: search
         )
     )}
  end

  def handle_event("close_modal", _value, socket) do
    {:noreply,
     socket
     |> assign(selected: nil)}
  end

  def handle_event("save", %{"add_agro_florestry_data" => params}, socket) do
    params
    |> Map.put("uuid", socket.assigns.selected.uuid)
    |> AddAgroFlorestryData.execute()
    |> case do
      :ok ->
        {:noreply,
         socket
         |> assign(selected: nil)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end

  def handle_event("select", %{"uuid" => uuid}, socket) do
    spicie =
      %{
        uuid: uuid
      }
      |> GetSpicie.execute()

    changeset =
      spicie
      |> Map.from_struct()
      |> AddAgroFlorestryData.new()

    {:noreply,
     socket
     |> assign(selected: spicie)
     |> assign(changeset: changeset)}
  end

  def agroflorest_fields(assigns) do
    ~H"""
      <.form :let={f} for={@changeset} phx-submit="save">
      <.form_field
          type="select"
          options={[{"Não Classificado", nil} | Stratum.valid_types()]}
          form={f}
          field={:stratum}
          label={"Estrato"}
          disabled={@current_user.admin == false}
      />
      <.form_field
          type="select"
          options={[{"Não Classificado", nil} | Stage.valid_types()]}
          form={f}
          field={:stage}
          label={"Estágio"}
          disabled={@current_user.admin == false}
      />
      <%= if @current_user.admin  do%>
        <div class="mt-5">
        <.button class="w-full rounded" type="submit" label="Modificar" />
      </div>
      <% end %>
    </.form>    
    """
  end

  def selected_modal(assigns) do
    ~H"""
    <.modal max_width="xl">
      <div class="flex gap-4 h-2/3 mb-2">
            <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.F00dCf4bXxX0J-qEEf4qIQHaD6%26pid%3DApi&f=1&ipt=cebacfbc2aa329e900e94846bed25a70a487c7be854f270204267fea9ef9ec94&ipo=images" />
            <div class="flex flex-col gap-2">
              <.h1 no_margin> <%= @selected.variety %> </.h1>
              <.h3 no_margin> <%= @selected.name %> </.h3>
              <.agroflorest_fields changeset={@changeset} current_user={@current_user} />
            </div>
      </div>
      <%= unless Enum.empty?([]) do %>
      <div class= "p-2">
          <.h2> Consórcios </.h2>
          <div class="w-full h-full flex gap-2">
          <div class="flex flex-col justify-center">
            <.icon_button size="xs" link_type="live_redirect" to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryIndexLive)}>
                  <Heroicons.chevron_left solid />
            </.icon_button>          </div>
          <div class="grid grid-cols-5 gap-2          <div class=">
          <%= for c <- [] do %>
              <.card >
                  <.card_media src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.F00dCf4bXxX0J-qEEf4qIQHaD6%26pid%3DApi&f=1&ipt=cebacfbc2aa329e900e94846bed25a70a487c7be854f270204267fea9ef9ec94&ipo=images" >
                  </.card_media>
                  <.card_content  class="max-w-sm py-2 px-3" heading={c}> 
                  </.card_content>
              </.card>
          <% end %>
          </div>
          <div class="flex flex-col justify-center">
            <.icon_button size="xs" link_type="live_redirect" to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryIndexLive)}>
                  <Heroicons.chevron_right solid />
            </.icon_button>
          </div>
          </div>
      </div>
      <% end %>
    </.modal>

    """
  end

  def card_icon(assigns) do
    ~H"""
    <div class={"rounded-full z-30 p-4 " <> @color}>
      <.icon name={@icon} class="text-white h-3"/>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="fixed top-0 left-96 right-72 z-30 h-16 flex justify-center">
        <div class="flex flex-col justify-center h-full w-full">
        <.form :let={f} for={:search_spicie} phx-change="search" phx-submit="send"  class="w-full">
            <.form_field type="search_input"
                         form={f}
                         class="mx-20"
                         value={@search}
                         field={:name}
                         label={"Nome"}
                         placeholder="Filtar por Nome"/>
        </.form>
        </div>
    </div>
    <.container class="relative z-20 w-full">
    <div class="grid gap-4 grid-cols-4 w-full">
        <%= for s <- @species do %>
          <a class="hover:scale-105"
              phx-value-uuid={s.uuid}
              phx-click={"select"}>
            <.card >
                <.card_media src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.F00dCf4bXxX0J-qEEf4qIQHaD6%26pid%3DApi&f=1&ipt=cebacfbc2aa329e900e94846bed25a70a487c7be854f270204267fea9ef9ec94&ipo=images" >
                </.card_media>
                <%= if false do %>  
                  <div class="-mt-6 flex w-full px-4 justify-end gap-2">
                      <.card_icon icon={:plus} color={"bg-primary-900"}/>
                      <.card_icon icon={:plus} color={"bg-secondary-900"}/>
                  </div>
                <% end %>
                <.card_content  class="max-w-sm py-2 px-3" heading={s.variety}> 
                </.card_content>
            </.card>
          </a>
        <% end %>
    </div>
    <%= if @species.total_pages > 1 do %>
      <div class="w-full flex justify-center pt-4" phx-window-keydown="paginate">
        <.pagination link_type="live_redirect" class="mb-5" path={fn page -> Routes.live_path(@socket, __MODULE__, [page: page, search: @search]) end} current_page={@species.page_number} total_pages={@species.total_pages} />
      </div>
    <% end %>
    </.container>

    <%= if @selected do %>
      <.selected_modal selected={@selected} changeset={@changeset} current_user={@current_user}/>
    <% end %>
    """
  end
end
