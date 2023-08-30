defmodule RecomendationFront.Territories.Infrastrucure.PubSub do
  use Commanded.Commands.Router

  def subscribe_territory_created(user_id) do
    Phoenix.PubSub.subscribe(RecomendationFront.PubSub, "territory_created/#{user_id}")
  end

  def subscribe_history_created(territory_uuid) do
    Phoenix.PubSub.subscribe(RecomendationFront.PubSub, "history_created/#{territory_uuid}")
  end

  def subscribe_task_created(territory_uuid) do
    Phoenix.PubSub.subscribe(RecomendationFront.PubSub, "task_created/#{territory_uuid}")
  end

  def subscribe_crop_scheduled(territory_uuid) do
    Phoenix.PubSub.subscribe(RecomendationFront.PubSub, "crop_scheduled/#{territory_uuid}")
  end

  def broadcast_task_created(territory_uuid, event) do
    Phoenix.PubSub.broadcast(
      RecomendationFront.PubSub,
      "task_created/#{territory_uuid}",
      task_created: event
    )
  end

  def broadcast_crop_scheduled(territory_uuid, event) do
    Phoenix.PubSub.broadcast(
      RecomendationFront.PubSub,
      "crop_scheduled/#{territory_uuid}",
      crop_scheduled: event
    )
  end

  def broadcast_history_created(user_id, event) do
    Phoenix.PubSub.broadcast(
      RecomendationFront.PubSub,
      "history_created/#{user_id}",
      history_created: event
    )
  end

  def broadcast_territory_created(user_id) do
    Phoenix.PubSub.broadcast(
      RecomendationFront.PubSub,
      "territory_created/#{user_id}",
      :territory_created
    )
  end
end
