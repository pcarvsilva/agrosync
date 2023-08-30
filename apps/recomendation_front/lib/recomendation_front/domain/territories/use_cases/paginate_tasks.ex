defmodule RecomendationFront.Territories.UseCases.PaginateTaks do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.PlantingTask

  @default_params %{page_size: 8}

  import Ecto.Query

  def execute(params) do
    params = @default_params |> Map.merge(params)
    user_id = params[:user_id]

    PlantingTask
    |> preload(:territory)
    |> where([h], h.user_id == ^user_id)
    |> order_by([h], asc: h.date)
    |> Repo.paginate(params)
  end
end
