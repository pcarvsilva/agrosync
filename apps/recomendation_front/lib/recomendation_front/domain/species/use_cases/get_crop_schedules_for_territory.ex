defmodule RecomendationFront.Spicies.UseCases.GetCropSchedulesForTerritory do
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.CropSchedule

  import Ecto.Query

  def execute(params) do
    territory_uuid = params[:territory_uuid]
    first_date = params[:date]
    last_date = params[:date] |> Timex.shift(months: 7) |> Timex.end_of_month()

    CropSchedule
    |> where([s], s.territory_uuid == ^territory_uuid)
    |> where(
      [s],
      (s.planting_date >= ^first_date and s.planting_date <= ^last_date) or
        (s.harvesting_date >= ^first_date and s.harvesting_date <= ^last_date)
    )
    |> Repo.all()
  end
end
