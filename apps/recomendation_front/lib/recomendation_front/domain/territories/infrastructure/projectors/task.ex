defmodule RecomendationFront.Infrastructure.Territories.Projectors.PlantingTasks do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Territories.Projectors.PlantingTasks"

  alias RecomendationFront.Territories.Domain.Events.TaskAddedToTerritory
  alias RecomendationFront.Territories.Domain.Projections.PlantingTask
  alias RecomendationFront.Territories.UseCases.GetTerritory
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  project(%TaskAddedToTerritory{} = event, fn multi ->
    t = GetTerritory.execute(%{uuid: event.uuid})

    multi
    |> Ecto.Multi.insert(
      :create_territory,
      %PlantingTask{
        territory_uuid: event.uuid,
        description: event.description,
        date: event.date |> Timex.to_naive_datetime(),
        user_id: t.owner_id
      }
    )
  end)

  def after_update(%TaskAddedToTerritory{} = event, _metadata, _changes) do
    PubSub.broadcast_task_created(event.uuid, event)
    :ok
  end
end
