class OrderItemPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @order_item = model
  end

  def new?
    @current_user.present? and @current_user.admin?
  end

  def create?
    #@current_user.present? and @current_user.admin?
    @current_user.present? and (@current_user.id == Order.find(@cart_item.cart_id).user_id or @current_user.admin?)
  end
end