defmodule RecomendationFront.Territory.Supervisor do
  use Supervisor

  alias RecomendationFront.Infrastructure.Territories.Projectors

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Projectors.Territory,
      Projectors.History,
      Projectors.PlantingTasks
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
