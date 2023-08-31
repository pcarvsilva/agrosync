defmodule RecomendationFront.Infrastructure.Territories.Projectors.History do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Territories.Projectors.History"

  alias RecomendationFront.Territories.Domain.Events.{
    TerritoryCreated,
    TaskAddedToTerritory,
    HistoryAddedToTerritory
  }

  alias RecomendationFront.Territories.Domain.Projections.History
  alias RecomendationFront.Territories.UseCases.GetTerritory
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  project(%TerritoryCreated{} = event, metadata, fn multi ->
    multi
    |> Ecto.Multi.insert(
      :create_history,
      %History{
        territory_uuid: event.uuid,
        description: "Criou o Território",
        date: metadata.created_at |> NaiveDateTime.truncate(:second) |> Timex.to_naive_datetime(),
        user_id: event.owner_id
      }
    )
  end)

  project(%HistoryAddedToTerritory{} = event, metadata, fn multi ->
    multi
    |> Ecto.Multi.insert(
      :create_history,
      %History{
        territory_uuid: event.uuid,
        description: event.description,
        date: metadata.created_at |> NaiveDateTime.truncate(:second) |> Timex.to_naive_datetime(),
        user_id: event.owner_id
      }
    )
  end)

  project(%TaskAddedToTerritory{} = event, metadata, fn multi ->
    t = GetTerritory.execute(%{uuid: event.uuid})

    date_formated = Timex.format!(event.date, "{0D}/{0M}")

    multi
    |> Ecto.Multi.insert(
      :create_history,
      %History{
        territory_uuid: event.uuid,
        description: "Programou a tarefa de #{event.description} para o dia #{date_formated}",
        date: metadata.created_at |> NaiveDateTime.truncate(:second) |> Timex.to_naive_datetime(),
        user_id: t.owner_id
      }
    )
  end)

  def after_update(event, _metadata, changes) do
    PubSub.broadcast_history_created(event.uuid, changes)
    :ok
  end
end
