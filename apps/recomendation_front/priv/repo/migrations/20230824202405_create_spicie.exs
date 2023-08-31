defmodule RecomendationFront.Repo.Migrations.CreateSpicie do
  use Ecto.Migration

  def change do
    create table(:spicie) do
      add(:uuid, :uuid, primary_key: true)
      add(:name, :string)
      add(:variety, :string)
      add(:cultivation_days, :integer)
      timestamps()
    end
  end
end
