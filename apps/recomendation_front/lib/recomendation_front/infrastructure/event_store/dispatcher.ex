defmodule RecomendationFront.Infrastructure.EventStore.Dispatcher do
  use Commanded.Application, otp_app: :recomendation_front
  use Commanded.CommandDispatchValidation

  alias RecomendationFront.Infrastructure

  router(Infrastructure.Territories.Router)
  router(Infrastructure.Spicies.Router)

  def dispatch_command(command) do
    command
    |> validate_and_dispatch()
    |> case do
      {:error, {:validation_failure, changeset}} ->
        {:error, changeset}

      :ok ->
        :ok
    end
  end
end
