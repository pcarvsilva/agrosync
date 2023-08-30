defmodule RecomendationFront.Spicies.Domain.Events.CropScheduled do
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:territory_uuid, :binary_id)
    field(:spiecie_uuid, :binary_id)
    field(:spiecie_variety, :binary_id)
    field(:date, :date)
    field(:cultivation_days, :integer)
  end
end

defimpl Commanded.Serialization.JsonDecoder,
  for: RecomendationFront.Spicies.Domain.Events.CropScheduled do
  alias RecomendationFront.Spicies.Domain.Events.CropScheduled

  @doc """
  Parse the datetime included in the event.
  """
  def decode(%CropScheduled{date: date} = event) do
    {:ok, dt} = Date.from_iso8601(date)

    %CropScheduled{event | date: dt}
  end
end
