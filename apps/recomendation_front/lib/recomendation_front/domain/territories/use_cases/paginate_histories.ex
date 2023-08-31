defmodule RecomendationFront.Territories.UseCases.PaginateHistories do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.History

  @default_params %{page_size: 8}

  import Ecto.Query

  def execute(params) do
    params = @default_params |> Map.merge(params)
    user_id = params[:user_id]

    History
    |> preload(:territory)
    |> where([h], h.user_id == ^user_id)
    |> order_by([h], desc: h.date)
    |> Repo.paginate(params)
  end
end
