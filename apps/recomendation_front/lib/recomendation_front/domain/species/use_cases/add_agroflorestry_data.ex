defmodule RecomendationFront.Spicies.UseCases.AddAgroFlorestryData do
  use Commanded.DDD.UseCase
  alias RecomendationFront.Infrastructure.EventStore.Dispatcher
  alias RecomendationFront.Spicies.Domain.Entities.{Stratum, Stage}
  alias RecomendationFront.Spicies.Domain.Commands.{AddStageToSpicies, AddStratumToSpicies}
  import Ecto.Changeset

  use_case do
    field(:uuid, :binary_id)
    field(:stratum, Stratum)
    field(:stage, Stage)
  end

  def execute(params) do
    params
    |> new()
    |> case do
      %{valid?: true} ->
        params
        |> AddStageToSpicies.new()
        |> Dispatcher.dispatch_command()

        params
        |> AddStratumToSpicies.new()
        |> Dispatcher.dispatch_command()

        :ok

      changeset ->
        {:error, changeset}
    end
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :stratum])
  end
end
