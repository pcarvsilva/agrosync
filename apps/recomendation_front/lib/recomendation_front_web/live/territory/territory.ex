defmodule RecomendationFrontWeb.TerritoryLive do
  use RecomendationFrontWeb, :live_view

  alias RecomendationFront.Territories.UseCases.{
    AddTaskToTerritory,
    PaginateHistoriesForTerritory,
    PaginateTasksForTerritory,
    GetTerritory,
    AddHistoryToTerritory
  }

  alias RecomendationFront.Spicies.UseCases.GetSpeciesForTerritory

  alias RecomendationFront.Territories.Infrastrucure.PubSub

  def mount(params, _session, socket) do
    PubSub.subscribe_history_created(params["id"])
    PubSub.subscribe_task_created(params["id"])
    PubSub.subscribe_crop_scheduled(params["id"])

    species =
      %{
        territory_uuid: params["id"]
      }
      |> GetSpeciesForTerritory.execute()

    histories =
      %{
        page_size: 7,
        user_id: socket.assigns.current_user.id,
        territory_uuid: params["id"]
      }
      |> PaginateHistoriesForTerritory.execute()

    territory =
      %{
        uuid: params["id"]
      }
      |> GetTerritory.execute()

    tasks =
      %{
        page_size: 5,
        user_id: socket.assigns.current_user.id,
        territory_uuid: params["id"]
      }
      |> PaginateTasksForTerritory.execute()

    history_changeset =
      %{
        territory_uuid: params["id"]
      }
      |> AddHistoryToTerritory.new()

    {:ok,
     socket
     |> assign(species: species)
     |> assign(territory: territory)
     |> assign(histories: histories)
     |> assign(new_histories: [])
     |> assign(tasks: tasks)
     |> assign(add_task_chageset: nil)
     |> assign(history_changeset: to_form(history_changeset))}
  end

  def handle_event("add_task", _, socket) do
    {:noreply,
     socket
     |> assign(add_task_chageset: AddTaskToTerritory.new())}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, socket |> assign(add_task_chageset: nil)}
  end

  def handle_event("save", %{"add_task_to_territory" => params}, socket) do
    params
    |> Map.put("uuid", socket.assigns.territory.uuid)
    |> AddTaskToTerritory.execute()
    |> case do
      :ok ->
        {:noreply, socket |> assign(add_task_chageset: nil)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(add_task_chageset: changeset)}
    end
  end

  def handle_event("validate", %{"add_task_to_territory" => params}, socket) do
    changeset =
      params
      |> Map.put("uuid", socket.assigns.territory.uuid)
      |> AddTaskToTerritory.new()

    {:noreply,
     socket
     |> assign(add_task_chageset: changeset)}
  end

  def handle_event("save", %{"add_history_to_territory" => params}, socket) do
    params
    |> Map.put("uuid", socket.assigns.territory.uuid)
    |> AddHistoryToTerritory.execute()
    |> case do
      :ok ->
        new_changeset =
          %{
            uuid: socket.assigns.territory.uuid
          }
          |> AddHistoryToTerritory.new()

        {:noreply,
         socket
         |> assign(history_changeset: to_form(new_changeset))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(history_changeset: to_form(changeset))}
    end
  end

  def handle_event("validate", %{"add_history_to_territory" => params}, socket) do
    changeset =
      params
      |> Map.put("uuid", socket.assigns.territory.uuid)
      |> AddHistoryToTerritory.new()

    {:noreply,
     socket
     |> assign(history_changeset: to_form(changeset))}
  end

  def handle_event("load-more", _, socket) do
    histories =
      %{
        page: socket.assigns.histories.page_number + 1,
        page_size: 5,
        user_id: socket.assigns.current_user.id,
        territory_uuid: socket.assigns.territory.uuid
      }
      |> PaginateHistoriesForTerritory.execute()

    {:noreply, socket |> assign(histories: histories)}
  end

  def handle_info([history_created: event], socket) do
    {:noreply, socket |> assign(new_histories: [event |> Map.get(:create_history)])}
  end

  def handle_info(_, socket) do
    {:noreply,
     socket
     |> push_navigate(to: Routes.live_path(socket, __MODULE__, socket.assigns.territory_uuid))}
  end

  def right_side(assigns) do
    ~H"""
    <.card >
        <.card_content>
            <.h3> Espécies Cultivadas</.h3>
            <.table>
            <%= for s <- @species do %>
              <.tr>
                <.td> <%= s.variety %> </.td>
              </.tr>
            <% end %>
          </.table>
        </.card_content>
    </.card>
    """
  end

  def left_side(assigns) do
    ~H"""
    <div class="flex flex-col gap-2">
    <.card class="pb-2">
        <.card_media src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.F00dCf4bXxX0J-qEEf4qIQHaD6%26pid%3DApi&f=1&ipt=cebacfbc2aa329e900e94846bed25a70a487c7be854f270204267fea9ef9ec94&ipo=images" />
        <.card_content heading={@territory.name}> </.card_content>
    </.card>
    <.card >
        <.card_content>
            <.h3 > Próximas Tarefas </.h3>
            <.table >
            <%= for task <- @tasks do %>
              <.tr>
                <.td class="ml-1"> <.badge class="w-full" variant="outline"> <%= task.description %> </.badge> </.td>
                <.td class="pl-0"> <%= Timex.format!(task.date, "{0D}/{0M}") %> </.td>
              </.tr>
            <% end %>
            </.table>
            <.button label={"Adicionar Tarefa"} class="mt-2 w-full" phx-click={"add_task"} />
        </.card_content>
    </.card>
    </div>
    """
  end

  def add_task_modal(assigns) do
    ~H"""
    <.modal max_width="md" title="Adicionar nova tarefa">
       <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save">
           <.form_field
               type="text_input"
               form={f}
               field={:description}
               label={"Descrição"}
           />
           <.form_field
               type="date_input"
               form={f}
               field={:date}
               label={"Data"}
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

  def center(assigns) do
    ~H"""
    <div class="flex flex-col gap-2" >
        <.add_to_history changeset={@changeset}/>
        <div phx-update="prepend" id="new_feed" class="flex flex-col gap-2" >
        <%= for history <- @new_histories  do %>
            <.history_card history={history} id={history.id}/>
        <% end %>
        </div>
        <div phx-update="append" id="feed" class="flex flex-col gap-2" >
        <%= for history <- @histories  do %>
            <.history_card history={history} id={history.id}/>
        <% end %>
        </div>
    </div>
    <div id={"infinite"} phx-hook="InfiniteScroll" data-page={ @histories.page_number}></div>
    """
  end

  def add_to_history(assigns) do
    ~H"""
    <.card class="w-full" >
        <.card_content>
        <.form for={@changeset} phx-change="validate" phx-submit="save">
            <.field
                type="textarea"
              
                field={@changeset[:description]}
                label={" "}
            />
            <div class="mt-5">
            <.button class="w-full rounded" type="submit" label="Adicionar ao Historico" />
            </div>
        </.form>
        </.card_content>
    </.card>
    """
  end

  def history_card(assigns) do
    ~H"""
        <div class="px-4" id={"history-card-#{@id}"}>
        <.card class="w-full">
            <.card_content>
                <.h5 class="">  <%= @history.description %> </.h5>
                <.p class="float-right"> <%= @history.date |> Timex.format!("{h12}:{0m} - {0D}/{0M}")%> </.p>
            </.card_content>
        </.card>
        </div>
    """
  end

  def render(assigns) do
    ~H"""
    <.container class="grid grid-cols-4 gap-4">
      <div class="relative">
          <div class="sticky top-20  z-20">
              <.left_side territory={@territory} tasks={@tasks} socket={@socket}/>
          </div>
      </div>
      <div class="col-span-2 w-full z-20">
          <.center histories={@histories} new_histories={@new_histories} changeset={@history_changeset}/>
      </div>
      <div class="relative">
          <div class="sticky w-full top-20 z-20">
              <.right_side territory={@territory} species={@species} socket={@socket}/>
          </div>
      </div>
    </.container>
    <div class="fixed bottom-10 right-20">
      <.button link_type="live_redirect" to={Routes.live_path(@socket, RecomendationFrontWeb.ProductionPlanningLive, @territory.uuid)} class="rounded-full z-30 p-3" color="primary" size="xl">
        <.icon name={:pencil} class="w-8 h-8" />
      </.button>
    </div>

    <%= if @add_task_chageset  do %>
      <.add_task_modal changeset={@add_task_chageset}/>
    <% end %>
    """
  end
end
