defmodule RecomendationFrontWeb.Charts do
  use Phoenix.Component

  def bar_chart(assigns) do
    ~H"""
    <div class="w-full h-full" phx-update="ignore" id={"div-#{@chart_id}"}>
      <canvas id={@chart_id} phx-update="ignore" phx-hook="BarChart">
      </canvas>
    </div>
    """
  end
end
