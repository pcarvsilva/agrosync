defmodule RecomendationFrontWeb.FirstTerritoryLive do
  use RecomendationFrontWeb, :live_view
  alias RecomendationFront.Territories.Infrastrucure.PubSub
  alias RecomendationFront.Territories.UseCases.CreateTerritory

  def mount(_params, _session, socket) do
    PubSub.subscribe_territory_created(socket.assigns.current_user.id)

    {:ok,
     socket
     |> assign(changeset: CreateTerritory.new()),
     layout: {RecomendationFrontWeb.LayoutView, :no_sidenav}}
  end

  def handle_info(:territory_created, socket) do
    {:noreply,
     socket
     |> push_navigate(to: Routes.live_path(socket, RecomendationFrontWeb.PageLive))}
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

  def render(assigns) do
    ~H"""
    <.container class="relative z-20 w-full">
        <.card class="h-2/3">
            <.card_content >
                <.h1 > Adicione sua primeira Zona de Cultivo </.h1>
                <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save" >
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
         </.card_content>
       </.card>
    </.container>
    """
  end
end
