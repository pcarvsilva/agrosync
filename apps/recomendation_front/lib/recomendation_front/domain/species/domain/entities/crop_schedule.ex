defmodule RecomendationFront.Spicies.Domain.Entities.CropSchedule do
  use Ecto.Schema

  embedded_schema do
    field(:uuid, :binary_id)
    field(:spiecie_uuid, :binary_id)
    field(:spiecie_variety, :binary_id)
    field(:territory_uuid, :binary_id)
    field(:date, :date)
    field(:cultivation_days, :integer)
  end

  alias __MODULE__

  alias RecomendationFront.Spicies.Domain.Commands.ScheduleCrop
  alias RecomendationFront.Spicies.Domain.Events.CropScheduled
  alias RecomendationFront.Territories.Domain.Events.TaskAddedToTerritory

  def execute(%CropSchedule{uuid: nil}, %ScheduleCrop{} = command) do
    [
      %CropScheduled{
        uuid: command.uuid,
        spiecie_uuid: command.spiecie_uuid,
        spiecie_variety: command.spiecie_variety,
        territory_uuid: command.territory_uuid,
        date: command.date,
        cultivation_days: command.cultivation_days
      },
      %TaskAddedToTerritory{
        uuid: command.territory_uuid,
        description: "Plantar #{command.spiecie_variety}",
        date: command.date
      },
      %TaskAddedToTerritory{
        uuid: command.territory_uuid,
        description: "Colher #{command.spiecie_variety}",
        date: command.date |> Timex.shift(days: command.cultivation_days)
      }
    ]
  end

  def execute(%CropSchedule{}, %ScheduleCrop{}), do: {:error, :already_registered}

  def apply(_, %CropScheduled{} = evt) do
    %CropSchedule{
      uuid: evt.uuid,
      spiecie_uuid: evt.spiecie_uuid,
      spiecie_variety: evt.spiecie_variety,
      territory_uuid: evt.territory_uuid,
      date: evt.date,
      cultivation_days: evt.cultivation_days
    }
  end

  def apply(schedule, _) do
    schedule
  end
end
