defmodule RecomendationFrontWeb.CalendarLive do
  use RecomendationFrontWeb, :live_view
  alias RecomendationFront.Territories.UseCases.GetTasksForMonth

  def mount(_params, _session, socket) do
    first_day = Timex.today() |> Timex.beginning_of_month()
    id = socket.assigns.current_user.id

    {:ok,
     socket
     |> assign(first_day: first_day)
     |> assign(events_for_month: get_events_for_month(first_day, id))}
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

  def paginate_next(socket) do
    next_day = socket.assigns.first_day |> Timex.shift(months: 1)
    id = socket.assigns.current_user.id

    {:noreply,
     socket
     |> assign(first_day: next_day)
     |> assign(events_for_month: get_events_for_month(next_day, id))}
  end

  defp paginate_previous(socket) do
    previous_day = socket.assigns.first_day |> Timex.shift(months: -1)
    id = socket.assigns.current_user.id

    {:noreply,
     socket
     |> assign(first_day: previous_day)
     |> assign(events_for_month: get_events_for_month(previous_day, id))}
  end

  defp get_month_offset(1, first_day) do
    first_day
    |> Timex.weekday!()
    |> get_offset_class()
  end

  defp get_month_offset(_, _) do
    ""
  end

  defp get_events_for_month(first_date, user_id) do
    GetTasksForMonth.execute(%{first_date: first_date, user_id: user_id})
  end

  defp get_offset_class(1), do: "col-start-1"
  defp get_offset_class(2), do: "col-start-2"
  defp get_offset_class(3), do: "col-start-3"
  defp get_offset_class(4), do: "col-start-4"
  defp get_offset_class(5), do: "col-start-5"
  defp get_offset_class(6), do: "col-start-6"
  defp get_offset_class(7), do: ""

  def day(assigns) do
    ~H"""
    <div class={"flex flex-col min-h-24 " <> get_month_offset(@index, @first_day)}>
      <p class="pl-2 mb-1 font-bold bg-gray-100"><%= @index %></p>
      <div class="flex flex-col px-1 py-1 overflow-auto gap-1">
      <%= for activity <- @activities do %>
          <.badge class="mx-4" variant="outline"> <%= activity.description %> </.badge>      
      <% end %>
      </div>
    </div>
    """
  end

  def week_days(assigns) do
    ~H"""
      <div class="w-full grid grid-cols-7 h-8 font-bold text-black flex-none border-b">
          <div class="px-2">Seg</div>
          <div class="px-2">Ter</div>
          <div class="px-2">Qua</div>
          <div class="px-2">Qui</div>
          <div class="px-2">Sex</div>
          <div class="px-2">Sab</div>
          <div class="px-2">Dom</div>
      </div>
    """
  end

  def top_bar(assigns) do
    ~H"""
      <div class="flex justify-between w-full border-b">
          <.h1> Calendário de Manejo </.h1>
          <div class="flex flex-col justify-end pr-4 pb-4">
              <div class="flex gap-2" phx-window-keydown="paginate">
                  <.icon_button phx-click={"previous"}>
                      <Heroicons.chevron_left class="h-8" />
                  </.icon_button>
                  <.h2 no_margin> <%= Timex.format!(@first_day, "{0M}/{YY}") %></.h2>
                  <.icon_button phx-click={"next"}>
                      <Heroicons.chevron_right class="h-8" />
                  </.icon_button>
              </div>
          </div>
      </div>
    """
  end

  def render(assigns) do
    ~H"""
    <.container class="relative z-20 h-screen">
        <.card class="z-20 h-5/6">
            <.card_content class="flex flex-col gap-2">
              <.top_bar first_day={@first_day} />
                <div class="flex flex-col flex-grow pt-2">
                    <.week_days />
                    <div class="grid flex-grow w-full grid-cols-7">
                        <%= for index <- 1..Timex.days_in_month(@first_day) do %>
                          <.day index={index} 
                            first_day={@first_day} 
                            activities={@events_for_month[index] || []} />
                      <% end %>
                    </div>
                </div>
            </.card_content>
        </.card>
    </.container>
    """
  end
end
