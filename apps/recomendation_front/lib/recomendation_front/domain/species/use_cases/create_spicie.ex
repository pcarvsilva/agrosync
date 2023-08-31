defmodule RecomendationFront.Spicies.UseCases.CreateSpicie do
  alias RecomendationFront.Spicies.Domain.Commands
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
    |> add_uuid()
    |> Commands.CreateSpicie.new()
    |> Map.put(:action, :validate)
  end

  defp add_uuid(params) do
    params
    |> Map.put("uuid", Ecto.UUID.generate())
  end
end
