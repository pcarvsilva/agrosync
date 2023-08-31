defmodule RecomendationFront.Repo.Migrations.CreateHistory do
  use Ecto.Migration

  def change do
    create table(:history) do
      add(:description, :string)
      add(:date, :naive_datetime)
      add(:user_id, :integer)
      add(:territory_uuid, :uuid)
      timestamps()
    end
  end
end
