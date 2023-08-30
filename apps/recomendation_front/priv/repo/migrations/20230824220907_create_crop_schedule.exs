defmodule RecomendationFront.Repo.Migrations.CreateCropSchedule do
  use Ecto.Migration

  def change do
    create table(:crop_schedule) do
      add(:uuid, :binary_id, primary_key: true)
      add(:spiecie_uuid, :binary_id)
      add(:spiecie_variety, :string)
      add(:territory_uuid, :binary_id)
      add(:planting_date, :date)
      add(:harvesting_date, :date)
      add(:cultivation_days, :integer)

      timestamps()
    end
  end
end
