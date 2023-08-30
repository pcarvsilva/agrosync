defmodule RecomendationFront.Application do
  @moduledoc false

  use Application

  alias RecomendationFront.Infrastructure
  alias RecomendationFront.Territory
  alias RecomendationFront.Spicies

  @impl true
  def start(_type, _args) do
    children = [
      RecomendationFront.Repo,
      RecomendationFrontWeb.Telemetry,
      {Phoenix.PubSub, name: RecomendationFront.PubSub},
      RecomendationFrontWeb.Endpoint,
      Infrastructure.Supervisor,
      Territory.Supervisor,
      Spicies.Supervisor
    ]

    opts = [strategy: :one_for_one, name: RecomendationFront.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    RecomendationFrontWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
