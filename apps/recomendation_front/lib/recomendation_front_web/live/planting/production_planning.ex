defmodule RecomendationFrontWeb.ProductionPlanningLive do
  @moduledoc false
  use RecomendationFrontWeb, :live_view

  alias RecomendationFront.Territories.UseCases.GetTerritory
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  alias RecomendationFront.Spicies.UseCases.{
    GetAllSpicies,
    ScheduleCrop,
    GetCropSchedulesForTerritory
  }

  def mount(params, _session, socket) do
    PubSub.subscribe_crop_scheduled(params["id"])
    {:ok, socket, layout: false}
  end

  def handle_info(_, socket) do
    {:noreply,
     socket
     |> push_navigate(to: Routes.live_path(socket, __MODULE__, socket.assigns.territory_uuid))}
  end

  def handle_params(params, _session, socket) do
    territory =
      %{
        uuid: params["id"]
      }
      |> GetTerritory.execute()

    spicies = GetAllSpicies.execute()

    first_day = Timex.today() |> Timex.beginning_of_month()

    crops = get_crops(params["id"], first_day)

    {:noreply,
     socket
     |> assign(
       to_delete: nil,
       schedule_crop_changeset: nil,
       territory: territory,
       species: spicies,
       crops: crops,
       first_day: first_day
     )}
  end

  def paginate_next(socket) do
    next_day = socket.assigns.first_day |> Timex.shift(months: 1)
    id = socket.assigns.territory.uuid

    {:noreply,
     socket
     |> assign(first_day: next_day)
     |> assign(crops: get_crops(id, next_day))}
  end

  defp paginate_previous(socket) do
    previous_day = socket.assigns.first_day |> Timex.shift(months: -1)
    id = socket.assigns.territory.uuid

    {:noreply,
     socket
     |> assign(first_day: previous_day)
     |> assign(crops: get_crops(id, previous_day))}
  end

  defp get_crops(territory_uuid, date) do
    %{
      territory_uuid: territory_uuid,
      date: date
    }
    |> GetCropSchedulesForTerritory.execute()
    |> format_crops_for_territory(date)
  end

  defp format_crops_for_territory(crops, date) do
    crops
    |> Enum.map(fn c ->
      {c.spiecie_variety,
       {
         max(0, c.planting_date |> Timex.diff(date, :months)),
         max(0, c.harvesting_date |> Timex.diff(date, :months))
       }}
    end)
  end

  @months ["Jan", "Fev", "Mar", "Abr", "Maio", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]

  defp get_months(date) do
    month_index = date.month

    first_months =
      @months
      |> Enum.drop(month_index - 1)
      |> Enum.take(7)

    (first_months ++ @months) |> Enum.take(7)
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, socket |> assign(:schedule_crop_changeset, nil) |> assign(:to_delete, nil)}
  end

  def handle_event("schedule_crop", _, socket) do
    {:noreply, socket |> assign(:schedule_crop_changeset, ScheduleCrop.new())}
  end

  def handle_event("clicked_crop", %{"index" => index}, socket) do
    {index, _} = Integer.parse(index)

    {:noreply,
     socket
     |> assign(:to_delete, socket.assigns.crops |> Enum.at(index))}
  end

  def handle_event("save", %{"schedule_crop" => params}, socket) do
    params
    |> Map.put("territory_uuid", socket.assigns.territory.uuid)
    |> ScheduleCrop.execute()
    |> case do
      :ok ->
        {:noreply, socket |> assign(schedule_crop_changeset: nil)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(schedule_crop_changeset: changeset)}
    end
  end

  def handle_event("validate", %{"schedule_crop" => params}, socket) do
    changeset =
      params
      |> Map.put("territory_uuid", socket.assigns.territory.uuid)
      |> ScheduleCrop.new()

    {:noreply,
     socket
     |> assign(schedule_crop_changeset: changeset)}
  end

  def handle_event("previous", _, socket) do
    paginate_previous(socket)
  end

  def handle_event("next", _, socket) do
    paginate_next(socket)
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    paginate_next(socket)
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    paginate_previous(socket)
  end

  def handle_event("paginate", _, socket) do
    {:noreply, socket}
  end

  def schedule_crop_modal(assigns) do
    ~H"""
    <.modal max_width="md" title="Agendar Plantio">
    <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save">
           <.form_field
               type="select"
               options={[{"Escolha uma espécie", nil}] ++ (@species |> Enum.map(fn a -> {a.variety, a.uuid} end))}
               form={f}
               label="Espécie"
               field={:spiecie_uuid}
           />
           <.form_field
               type="date_input"
               form={f}
               label="Data de Plantio"
               field={:date}
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

  def top_bar(assigns) do
    ~H"""
      <div class="w-full flex">
      <div class="w-60 flex justify-end">
        <div class="flex flex-col justify-center"> 
          <.icon_button link_type="live_redirect" to={Routes.live_path(@socket, RecomendationFrontWeb.TerritoryLive, @territory.uuid)}>
            <Heroicons.chevron_left class="h-12 text-white pb-2" />
          </.icon_button>
        </div>
      </div>
      <div class="flex justify-between flex-grow">
          <.h1 class="text-white"> <%= @territory.name %> </.h1>
          <div class="flex flex-col justify-end pr-4 pb-4">
              <div class="flex gap-2" phx-window-keydown="paginate">
                  <.icon_button phx-click={"previous"}>
                      <Heroicons.chevron_left class="h-8  text-white" />
                  </.icon_button>
                  <.h2 no_margin class=" text-white"> <%= Timex.format!(@first_day, "{0M}/{YY}") %></.h2>
                  <.icon_button phx-click={"next"}>
                      <Heroicons.chevron_right class="h-8  text-white" />
                  </.icon_button>
              </div>
          </div>
      </div>
      </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="z-30 sticky inset-0 bg-background w-full h-40 flex flex-col justify-end">
      <.top_bar territory={@territory} first_day={@first_day} socket={@socket}/>
    </div>
    <div class="grid grid-cols-8 bg-white h-12 flex-none border-b-2 sticky top-40 z-30">
      <div class="text-sm"></div>
      <%= for date <- get_months(@first_day) do %>
          <div class="text-sm border-gray-200 border-l text-center"> 
            <p class="h-8 p-2"> <%= date %> </p>
          </div>
      <% end %>
    </div>
    <div class="flex flex-col p-0">
        <div class="grid w-full h-full flex-none sticky" style="grid-template-columns: repeat(8, minmax(0, 1fr)); background: repeating-linear-gradient( to right, #efefef, #ddd 2px, #f3f0e9 2px, #f0ede4 12.5%);">
        <%= for {{name, {start_date, end_date}}, index} <- @crops |> Enum.with_index() do %>
                <div class="p-3 text-center font-bold border-b bg-white" style={"grid-row: #{index + 2} ; grid-column: 1 / span 1;"}>
                  <p class="truncate h-6"><%= name %> </p>
                </div>
            <div class="rounded-lg mx-3 my-3 bg-secondary-900 opacity-90 hover:bg-primary-900 h-6" style={"grid-row: #{index + 2} ; grid-column: #{start_date + 2}/ span #{min(7, end_date) - start_date + 2};"}  phx-click="clicked_crop" phx-value-index={index}>
            </div>
        <% end %>
        </div>
    </div>
    <div class="fixed bottom-10 right-20">
      <.button phx-click={"schedule_crop"} class="rounded-full z-30 p-3" color="primary" size="xl">
        <.icon name={:plus} class="w-8 h-8" />
      </.button>
    </div>


    <%= if @to_delete do %>
      <.modal max_width="sm" title="Excluir planejamento">
      <.p>Deseja excluir <%=  @to_delete |> elem(0)%> ?</.p>

      <div class="flex justify-end">
        <.button label="close" phx-click={PetalComponents.Modal.hide_modal()} />
      </div>
      </.modal>
    <% end %>


    <%= if @schedule_crop_changeset do %>
      <.schedule_crop_modal changeset={@schedule_crop_changeset} species={@species}/>
    <% end %>
    """
  end
end
