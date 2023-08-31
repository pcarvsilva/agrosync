defmodule RecomendationFront.Territories.UseCases.GetTerritory do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.Territory

  import Ecto.Query

  def execute(params) do
    uuid = params[:uuid]

    Territory
    |> where([t], t.uuid == ^uuid)
    |> Repo.one()
  end
end
