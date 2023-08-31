defmodule RecomendationFront.Repo.Migrations.CreateFieldsOnSpicie do
  use Ecto.Migration

  def change do
    alter table(:spicie) do
      add(:stratum, :string)
      add(:stage, :string)
    end
  end
end
