defmodule RecomendationFront.Infrastructure.Territories.Router do
  use Commanded.Commands.Router

  alias RecomendationFront.Territories.Domain.Entities.Territory

  alias RecomendationFront.Territories.Domain.Commands.{
    AddTaskToTerritory,
    CreateTerritory,
    AddHistoryToTerritory
  }

  identify(Territory,
    by: :uuid,
    prefix: "territory-"
  )

  dispatch(AddTaskToTerritory, to: Territory)
  dispatch(AddHistoryToTerritory, to: Territory)
  dispatch(CreateTerritory, to: Territory)
end
