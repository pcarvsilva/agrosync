defmodule RecomendationFront.Territories.UseCases.GetTasksForMonth do
  alias RecomendationFront.Repo
  alias RecomendationFront.Territories.Domain.Projections.PlantingTask

  import Ecto.Query

  def execute(params) do
    user_id = params[:user_id]
    first_date = params[:first_date]

    PlantingTask
    |> preload(:territory)
    |> where([h], h.user_id == ^user_id)
    |> where(
      [h],
      fragment("date_part('month', ?)", h.date) ==
        fragment("date_part('month', CAST(? as date))", ^first_date) and
        fragment("date_part('year', ?)", h.date) ==
          fragment("date_part('year', CAST(? as date))", ^first_date)
    )
    |> Repo.all()
    |> Enum.group_by(fn task -> task.date.day end)
  end
end
