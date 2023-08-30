defmodule RecomendationFront.Territories.UseCases.PaginateTasksForTerritory do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.PlantingTask

  @default_params %{page_size: 8}

  import Ecto.Query

  def execute(params) do
    params = @default_params |> Map.merge(params)
    territory_uuid = params[:territory_uuid]

    PlantingTask
    |> where([t], t.territory_uuid == ^territory_uuid)
    |> order_by([h], asc: h.date)
    |> Repo.paginate(params)
  end
end
