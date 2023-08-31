defmodule RecomendationFront.Spicies.Domain.Projections.CropSchedule do
  use Ecto.Schema
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  schema "crop_schedule" do
    field(:uuid, :binary_id)
    field(:spiecie_variety, :string)
    field(:territory_uuid, :binary_id)
    field(:planting_date, :date)
    field(:harvesting_date, :date)
    field(:cultivation_days, :integer)

    belongs_to(:spiecie, Spicie,
      type: :binary_id,
      references: :uuid,
      foreign_key: :spiecie_uuid
    )

    timestamps()
  end
end
