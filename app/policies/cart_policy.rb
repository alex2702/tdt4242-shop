class CartPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @cart = model
  end

  def new?
    @current_user.present? and (@current_user.id == @cart.user_id or @current_user.admin?)
  end

  def create?
    @current_user.present? and (@current_user.id == @cart.user_id or @current_user.admin?)
  end

  def show?
    @current_user.present? and (@current_user.cart == @cart or @current_user.admin?)
  end

  def add_to_cart?
    @current_user.present? and (@current_user.id == @cart.user_id or @current_user.admin?)
  end

  def checkout?
    @current_user.present? and (@current_user.id == @cart.user_id or @current_user.admin?) and @cart.cart_items.count > 0
  end

  # only for dashboard

  def edit?
    @current_user.present? and @current_user.admin?
  end

  def destroy?
    @current_user.present? and @current_user.admin?
  end
end