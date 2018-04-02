class OrderItemsController < ApplicationController
  # restful action for creating a new order_item instance
  def new
    authorize OrderItem
    @order_item = OrderItem.new
  end

  # action for creating a new order_item instance from the given parameters
  def create
    @order_item = OrderItem.new(order_item_params)
    authorize @order_item
  end

  private

  # Only allow the whitelisted parameters.
  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :amount)
  end
end