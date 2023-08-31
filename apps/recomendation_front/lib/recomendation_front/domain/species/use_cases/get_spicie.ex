defmodule RecomendationFront.Spicies.UseCases.GetSpicie do
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  import Ecto.Query

  def execute(params) do
    uuid = params[:uuid]

    Spicie
    |> where([s], s.uuid == ^uuid)
    |> Repo.one()
  end
end
