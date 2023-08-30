defmodule RecomendationFrontWeb.MobileHook do
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    socket =
      assign_new(socket, :mobile, fn ->
        socket
        |> get_connect_info(:user_agent)
        |> Browser.mobile?()
      end)

    {:cont, socket}
  end
end
