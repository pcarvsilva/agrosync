defmodule RecomendationFront.Infrastructure.Spicies.Projectors.Spicie do
  use Commanded.Projections.Ecto,
    application: RecomendationFront.Infrastructure.EventStore.Dispatcher,
    repo: RecomendationFront.Repo,
    name: "Spicies.Projectors.Spicie"

  alias RecomendationFront.Repo

  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  alias RecomendationFront.Spicies.Domain.Events.{
    SpiecieCreated,
    StageAddedToSpicie,
    StratumAddedToSpicie
  }

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

  project(%StageAddedToSpicie{} = event, fn multi ->
    spicie = Spicie |> Repo.get_by!(uuid: event.uuid)

    multi
    |> Ecto.Multi.update(:update, fn _ ->
      Ecto.Changeset.change(spicie, stage: event.stage)
    end)
  end)

  project(%StratumAddedToSpicie{} = event, fn multi ->
    spicie = Spicie |> Repo.get_by!(uuid: event.uuid)

    multi
    |> Ecto.Multi.update(:update, fn _ ->
      Ecto.Changeset.change(spicie, stratum: event.stratum)
    end)
  end)
end
