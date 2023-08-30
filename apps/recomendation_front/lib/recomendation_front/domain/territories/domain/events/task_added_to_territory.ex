defmodule RecomendationFront.Territories.Domain.Events.TaskAddedToTerritory do
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:description, :string)
    field(:date, :date)
  end
end

defimpl Commanded.Serialization.JsonDecoder,
  for: RecomendationFront.Territories.Domain.Events.TaskAddedToTerritory do
  alias RecomendationFront.Territories.Domain.Events.TaskAddedToTerritory

  @doc """
  Parse the datetime included in the event.
  """
  def decode(%TaskAddedToTerritory{date: date} = event) do
    {:ok, dt} = Date.from_iso8601(date)

    %TaskAddedToTerritory{event | date: dt}
  end
end
