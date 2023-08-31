defmodule RecomendationFrontWeb.UserSettingsController do
  use RecomendationFrontWeb, :controller

  alias RecomendationFront.Accounts

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: "/")
    end
  end
end
