defmodule RecomendationFrontWeb.Router do
  use RecomendationFrontWeb, :router

  import RecomendationFrontWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {RecomendationFrontWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecomendationFrontWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: RecomendationFrontWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", RecomendationFrontWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", RecomendationFrontWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
  end

  scope "/", RecomendationFrontWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :default, on_mount: RecomendationFrontWeb.AuthHook do
      live("/", PageLive)
      live("/calendar", CalendarLive)

      scope "/users/settings" do
        live("/change_password", ChangePasswordLive)
        live("/change_email", ChangeEmailLive)
      end

      scope "/territory" do
        live("/", TerritoryIndexLive)
        live("/first", FirstTerritoryLive)
        live("/:id", TerritoryLive)
        live("/:id/production_planning", ProductionPlanningLive)
      end

      scope "/species" do
        live("/", SpiciesIndexLive)
      end
    end
  end

  scope "/users", RecomendationFrontWeb do
    pipe_through([:browser])

    delete("/log_out", UserSessionController, :delete)
    get("/confirm", UserConfirmationController, :new)
    post("/confirm", UserConfirmationController, :create)
    get("/confirm/:token", UserConfirmationController, :edit)
    post("/confirm/:token", UserConfirmationController, :update)
  end
end
