defmodule RecomendationFront.Spicies.UseCases.GetPaginatedSpicies do
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  @default_params %{page_size: 12}

  import Ecto.Query

  def execute(%{"search" => ""} = params) do
    params = @default_params |> Map.merge(params)

    Spicie
    |> order_by([s], s.variety)
    |> Repo.paginate(params)
  end

  def execute(%{"search" => name} = params) do
    params = @default_params |> Map.merge(params)

    start_character = String.slice(name, 0..1)

    Spicie
    |> where([p], ilike(p.variety, ^"#{start_character}%"))
    |> where([p], fragment("SIMILARITY(?, ?) > 0", p.variety, ^name))
    |> order_by([p], fragment("LEVENSHTEIN(?, ?)", p.variety, ^name))
    |> order_by([s], s.variety)
    |> Repo.paginate(params)
  end

  def execute(params) do
    params = @default_params |> Map.merge(params)

    Spicie
    |> order_by([s], s.variety)
    |> Repo.paginate(params)
  end
end
