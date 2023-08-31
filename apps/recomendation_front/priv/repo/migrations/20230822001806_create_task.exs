defmodule RecomendationFront.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add(:description, :string)
      add(:date, :naive_datetime)
      add(:user_id, :integer)
      add(:territory_uuid, :uuid)
      timestamps()
    end
  end
end
