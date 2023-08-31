defmodule RecomendationFront.Repo.Migrations.CreateTerritory do
  use Ecto.Migration

  def change do
    create table(:territory) do
      add(:uuid, :uuid, primary_key: true)
      add(:name, :string)
      add(:image, :string)
      add(:owner_id, :integer)
      timestamps()
    end
  end
end
