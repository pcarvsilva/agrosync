defmodule RecomendationFront.Infrastructure.Territories.Projectors.Territory do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Territories.Projectors.Territory"

  alias RecomendationFront.Territories.Domain.Events.TerritoryCreated
  alias RecomendationFront.Territories.Domain.Projections.Territory
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  project(%TerritoryCreated{} = event, fn multi ->
    multi
    |> Ecto.Multi.insert(
      :create_territory,
      %Territory{
        uuid: event.uuid,
        name: event.name,
        image: event.image,
        owner_id: event.owner_id
      }
    )
  end)

  def after_update(%TerritoryCreated{} = event, _metadata, _changes) do
    PubSub.broadcast_territory_created(event.owner_id)
    :ok
  end
end
