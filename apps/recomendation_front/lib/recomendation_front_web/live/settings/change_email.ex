defmodule RecomendationFrontWeb.ChangeEmailLive do
  use RecomendationFrontWeb, :live_view

  alias RecomendationFront.Accounts

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:email_changeset, Accounts.change_user_email(user))}
  end

  def handle_event("submit", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

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
         |> assign(:email_changeset, changeset)}
    end
  end

  def render(assigns) do
    RecomendationFrontWeb.UserSettingsView.render("change_email.html", assigns)
  end
end
