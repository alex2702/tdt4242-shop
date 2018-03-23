class CartItemPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @cart_item = model
  end

  def new?
    @current_user.present? and @current_user.admin?
  end

  def create?
    #@current_user.present? and @current_user.admin?
    @current_user.present? and (@current_user.id == Cart.find(@cart_item.cart_id).user_id or @current_user.admin?)
  end

  def destroy?
    @current_user.present? and (@current_user.id == Cart.find(@cart_item.cart_id).user_id or @current_user.admin?)
  end

  def update?
    @current_user.present? and (@current_user.id == Cart.find(@cart_item.cart_id).user_id or @current_user.admin?)
  end

  # only for dashboard

  def show?
    @current_user.present? and @current_user.admin?
  end

  def edit?
    @current_user.present? and @current_user.admin?
  end
end