defmodule RecomendationFrontWeb.Sidenav do
  use RecomendationFrontWeb, :live_component
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div id="sidenav"  class="sticky top-0 flex-none flex flex-col w-64 h-screen no-scrollbar bg-white">
    <div class="bg-background h-40">
      <img class="mx-auto" src={Routes.static_path(RecomendationFrontWeb.Endpoint, "/images/logo.png")} />
    </div>    
    <div class="overflow-y-auto bg-white flex flex-col justify-between flex-grow border-r">
      <ul>
          <li class="pb-1">
              <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.PageLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
                <.icon name={:home} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Página Principal
              </.a>
          </li>
          <li>
              <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.TerritoryIndexLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
                <.icon name={:photo} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Zonas de Cultivo
              </.a>
          </li>
          <li>
              <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.CalendarLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
                <.icon name={:calendar_days} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Calendário de Manejo
              </.a>
          </li>
          <li>
            <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.SpiciesIndexLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
              <.icon name={:book_open} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Catalogo de Cultivo
            </.a>
          </li>
          <li>
          <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.ChangePasswordLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
            <.icon name={:lock_closed} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Trocar Senha
          </.a>
          </li>
          <li>
            <.a link_type={"live_redirect"} to={Routes.live_path(RecomendationFrontWeb.Endpoint, RecomendationFrontWeb.ChangeEmailLive)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
              <.icon name={:envelope} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Trocar Email
            </.a>
          </li>
          <%= if @current_user.admin do %>
          <li>
            <.a link_type={"live_redirect"} to={Routes.user_registration_path(RecomendationFrontWeb.Endpoint, :new)} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
              <.icon name={:plus} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Adicionar Usuário
            </.a>
          </li>
          <% end %>
      </ul>
      <ul class="space-y-2">
        <li>
          <.a link_type={"a"} to={Routes.user_session_path(RecomendationFrontWeb.Endpoint, :delete)} method={:delete} class="h-12 flex items-center p-4 text-base font-normal text-gray-900   dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group">
            <.icon name={:arrow_right_on_rectangle} class="h-4 text-gray-700 dark:text-gray-300 pr-4"/> Sair
          </.a>
        </li>
      </ul>
    </div>
    </div>
    """
  end

  def show(js \\ %JS{}) do
    js
    |> JS.show(to: "#sidenav")
  end

  def hide(js \\ %JS{}) do
    js
    |> JS.hide(to: "#sidenav", transition: "fade-in-scale")
  end
end
