defmodule RecomendationFrontWeb.AsyncBarChartHook do
  import Phoenix.LiveView

  def assign_bar_chart_async(socket, chart_id, method) do
    id = "#{chart_id}"

    socket =
      socket
      |> attach_notification_hook(id)

    fetch_data_async(method, id)

    socket
  end

  defp fetch_data_async(method, id) do
    pid = self()

    Task.start(fn ->
      data = method.()
      send(pid, {id, data})
    end)
  end

  defp attach_notification_hook(socket, id) do
    id_atom = String.to_atom(id)

    socket
    |> attach_hook(id_atom, :handle_info, fn
      {some_id, assign_data}, socket ->
        if some_id != id do
          {:cont, socket}
        else
          {:halt,
           socket
           |> detach_hook(id_atom, :handle_info)
           |> notify_client(some_id, assign_data)}
        end

      _event, socket ->
        {:cont, socket}
    end)
  end

  defp notify_client(socket, id, assign_data) do
    chart_data = %{
      id: id,
      labels: assign_data |> Enum.map(fn [label, _data] -> label end),
      data: assign_data |> Enum.map(fn [_label, data] -> data end)
    }

    if chart_data.data do
      socket
      |> push_event("update_bar_chart", %{chart_data: chart_data})
    else
      socket
    end
  end
end
