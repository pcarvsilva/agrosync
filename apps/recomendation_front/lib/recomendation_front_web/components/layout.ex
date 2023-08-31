defmodule RecomendationFrontWeb.Layout do
  use Phoenix.Component

  def cols_range(_, mobile: true) do
    1..1
  end

  def cols_range(quantity, _) do
    1..quantity
  end

  def col_rem(col) do
    col - 1
  end

  def get_class_for_cols(_, mobile: true) do
    "grid grid-cols-1 gap-4"
  end

  def get_class_for_cols(1, _) do
    "grid grid-cols-1 gap-4"
  end

  def get_class_for_cols(2, _) do
    "grid grid-cols-2 gap-4"
  end

  def get_class_for_cols(3, _) do
    "grid grid-cols-3 gap-4"
  end

  def get_class_for_cols(4, _) do
    "grid grid-cols-4 gap-4"
  end

  def get_class_for_cols(5, _) do
    "grid grid-cols-5 gap-4"
  end

  def get_class_for_cols(6, _) do
    "grid grid-cols-6 gap-4"
  end

  def get_class_for_cols(7, _) do
    "grid grid-cols-7 gap-4"
  end

  def masonry(assigns) do
    assigns =
      assigns
      |> assign(
        :class,
        get_class_for_cols(assigns.cols_quantity,
          mobile: assigns.mobile
        )
      )
      |> assign(
        :range,
        cols_range(assigns.cols_quantity, mobile: assigns.mobile)
      )

    ~H"""
    <div class={@class}>
      <%=  for col_index <- @range do   %>
        <div id={"col-#{col_index}"} phx-update="append">
            <%=  for {element, index} <- Enum.with_index(@elements) do   %>
                <%= if rem(index, @cols_quantity) == col_rem(col_index) do%>
                  <%= render_slot(@element, element) %>
                <% end%>
            <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
