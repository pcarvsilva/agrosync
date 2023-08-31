defmodule RecomendationFront.Spicies.UseCases.ScheduleCrop do
  alias RecomendationFront.Spicies.Domain.Commands
  alias RecomendationFront.Infrastructure.EventStore.Dispatcher
  alias RecomendationFront.Repo
  alias RecomendationFront.Spicies.Domain.Projections.Spicie

  import Ecto.Query

  def execute(params) do
    params
    |> new()
    |> Dispatcher.dispatch_command()
    |> case do
      {:error, :already_registered} ->
        params |> execute()

      other ->
        other
    end
  end

  def new(params \\ %{}) do
    params
    |> add_spicies_data()
    |> add_uuid()
    |> Commands.ScheduleCrop.new()
    |> Map.put(:action, :validate)
  end

  defp add_uuid(params) do
    params
    |> Map.put("uuid", Ecto.UUID.generate())
  end

  defp add_spicies_data(params) do
    s = fetch_spicie(params["spiecie_uuid"])

    if s do
      params
      |> Map.put("cultivation_days", s.cultivation_days)
      |> Map.put("spiecie_variety", s.variety)
    else
      params
    end
  end

  defp fetch_spicie(nil), do: nil

  defp fetch_spicie(uuid) do
    Spicie
    |> where([s], s.uuid == ^uuid)
    |> Repo.one()
  end
end
