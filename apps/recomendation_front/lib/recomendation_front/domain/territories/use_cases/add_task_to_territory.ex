defmodule RecomendationFront.Territories.UseCases.AddTaskToTerritory do
  alias RecomendationFront.Territories.Domain.Commands
  alias RecomendationFront.Infrastructure.EventStore.Dispatcher

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
    |> Commands.AddTaskToTerritory.new()
    |> Map.put(:action, :validate)
  end
end
