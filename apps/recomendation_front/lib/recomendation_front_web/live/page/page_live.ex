defmodule RecomendationFrontWeb.PageLive do
  use RecomendationFrontWeb, :live_view

  alias RecomendationFront.Territories.UseCases.{
    PaginateTerritoriesForUser,
    PaginateHistories,
    PaginateTaks
  }

  def mount(_params, _session, socket) do
    territories =
      %{
        page_size: 4,
        user_id: socket.assigns.current_user.id
      }
      |> PaginateTerritoriesForUser.execute()

    case territories.entries do
      [] ->
        {:ok,
         socket
         |> push_navigate(to: Routes.live_path(socket, RecomendationFrontWeb.FirstTerritoryLive))}

      _ ->
        histories =
          %{
            page_size: 8,
            user_id: socket.assigns.current_user.id
          }
          |> PaginateHistories.execute()

        tasks =
          %{
            page_size: 7,
            user_id: socket.assigns.current_user.id
          }
          |> PaginateTaks.execute()

        {:ok,
         socket
         |> assign(
           territories: territories,
           histories: histories,
           tasks: tasks,
           new: false
         )}
    end
  end

  def territories_card(assigns) do
    ~H"""
    <.card class="flex-grow">
        <.card_content>
        <div class="flex justify-between">
          <.h2> Zonas de Cultivo </.h2>
          <.icon_button size="xs" link_type="live_redirect" to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryIndexLive)}>
                <Heroicons.chevron_right solid />
          </.icon_button>
        </div>
        <div class="flex gap-4 h-full">
          <%= for t <- @territories do %>
            <div class={"flex-grow h-full"} >
              <.a link_type="live_redirect" to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryLive, t.uuid)} >
                <.avatar  class="h-2/3 mt-4 w-full rounded-md" size="xl" name={t.name}/>
              </.a>
            </div>
          <% end %>
        </div>
        </.card_content>
    </.card>
    """
  end

  def calendar_card(assigns) do
    ~H"""
    <.card class="h-2/3">
      <.card_content>
      <div class="flex justify-between mb-4">
        <.h2> Calendário de Manejo </.h2>
        <.icon_button size="xs" link_type="live_redirect" to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.CalendarLive)}>
              <Heroicons.chevron_right solid />
        </.icon_button>
      </div>
      <.table>
        <.tr>
          <.th> Evento </.th>
          <.th> Data </.th>
        </.tr>
        <%= for task <- @tasks do %>
          <.tr>
            <.td> <%= task.description %> </.td>
            <.td> <%= Timex.format!(task.date, "{0D}/{0M}") %> </.td>
          </.tr>
        <% end %>
      </.table>
      </.card_content>
    </.card>
    """
  end

  def history_card(assigns) do
    ~H"""
      <.card class="h-full flex flex-col">
          <.card_content class="h-full">
          <.h2 > Histórico </.h2>
          <div class="h-full flex flex-col justify-center">
          <.table>
            <%= for history <- @histories do %>
              <.tr>
                <.td>
                <.a to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryLive, history.territory.uuid)} >
                <.user_inner_td
                  avatar_assigns={%{name: history.territory.name}}
                  label={history.territory.name}
                /> 
                </.a>
              </.td>
                <.td> <%= history.description %></.td>
                <.td> <%= Timex.format!(history.date, "{0D}/{0M}") %></.td>
              </.tr>
            <% end %>
          </.table>
          </div>
          </.card_content>
      </.card>
    """
  end

  def render(assigns) do
    ~H"""
    <.container class="relative z-20 h-screen">
      <div class="grid grid-cols-2 gap-4 h-5/6">
        <.history_card histories={@histories}/>
        <div class="flex flex-col h-full gap-2">
          <.territories_card territories={@territories} />
          <.calendar_card tasks={@tasks}/>
        </div>
      </div>
    </.container>
    """
  end
end
