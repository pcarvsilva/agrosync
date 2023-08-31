defmodule RecomendationFront.Spicies.UseCases.GetSpeciesForTerritory do
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.CropSchedule

  import Ecto.Query

  def execute(params) do
    territory_uuid = params[:territory_uuid]
    date = Timex.today()

    CropSchedule
    |> where([s], s.territory_uuid == ^territory_uuid)
    |> where(
      [s],
      s.planting_date <= ^date and s.harvesting_date >= ^date
    )
    |> preload(:spiecie)
    |> Repo.all()
    |> Enum.group_by(fn c -> c.spiecie end)
    |> Map.keys()
  end
end
