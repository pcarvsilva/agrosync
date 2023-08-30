defmodule RecomendationFront.Infrastructure.Spicies.Projectors.CropSchedule do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Spicies.Projectors.CropSchedule"

  alias RecomendationFront.Spicies.Domain.Events.CropScheduled
  alias RecomendationFront.Spicies.Domain.Projections.CropSchedule
  alias RecomendationFront.Territories.Infrastrucure.PubSub

  project(%CropScheduled{} = event, fn multi ->
    multi
    |> Ecto.Multi.insert(
      :create_crop_schedule,
      %CropSchedule{
        uuid: event.uuid,
        spiecie_uuid: event.spiecie_uuid,
        spiecie_variety: event.spiecie_variety,
        territory_uuid: event.territory_uuid,
        planting_date: event.date,
        harvesting_date: event.date |> Timex.shift(days: event.cultivation_days),
        cultivation_days: event.cultivation_days
      }
    )
  end)

  def after_update(%CropScheduled{} = event, _metadata, _changes) do
    PubSub.broadcast_crop_scheduled(event.territory_uuid, event)
    :ok
  end
end
