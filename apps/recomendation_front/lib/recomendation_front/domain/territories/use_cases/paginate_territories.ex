defmodule RecomendationFront.Territories.UseCases.PaginateTerritoriesForUser do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.Territory

  @default_params %{page_size: 8}

  import Ecto.Query

  def execute(params) do
    params = @default_params |> Map.merge(params)
    user_id = params[:user_id]

    Territory
    |> where([t], t.owner_id == ^user_id)
    |> Repo.paginate(params)
  end
end
