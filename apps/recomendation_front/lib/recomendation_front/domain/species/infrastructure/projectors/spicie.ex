defmodule RecomendationFront.Infrastructure.Spicies.Projectors.Spicie do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Spicies.Projectors.Spicie"

  alias RecomendationFront.Spicies.Domain.Events.SpiecieCreated
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  project(%SpiecieCreated{} = event, fn multi ->
    multi
    |> Ecto.Multi.insert(
      :create_spicie,
      %Spicie{
        uuid: event.uuid,
        variety: event.variety,
        name: event.name,
        cultivation_days: event.cultivation_days
      }
    )
  end)
end
