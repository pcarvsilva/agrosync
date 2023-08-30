defmodule RecomendationFrontWeb.AuthHook do
  import Phoenix.Component
  import Phoenix.LiveView
  # from `mix phx.gen.auth`
  alias RecomendationFront.Accounts
  alias RecomendationFrontWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
    end
  end
end
