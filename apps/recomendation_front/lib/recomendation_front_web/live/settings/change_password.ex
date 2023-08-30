defmodule RecomendationFrontWeb.ChangePasswordLive do
  use RecomendationFrontWeb, :live_view

  alias RecomendationFront.Accounts

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:password_changeset, Accounts.change_user_password(user))}
  end

  def handle_event("submit", params, socket) do
    %{"user" => %{"current_password" => password}} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "A link to confirm your email change has been sent to the new address."
         )
         |> redirect(to: "/")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:password_changeset, changeset)}
    end
  end

  def render(assigns) do
    RecomendationFrontWeb.UserSettingsView.render("change_password.html", assigns)
  end
end
