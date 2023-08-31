defmodule RecomendationFront.Spicies.UseCases.GetAllSpicies do
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  import Ecto.Query

  def execute() do
    Spicie
    |> order_by([s], s.variety)
    |> Repo.all()
  end
end
