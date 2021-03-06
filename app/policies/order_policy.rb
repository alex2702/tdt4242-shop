class OrderPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @order = model
  end

  def new?
    @current_user.present? and (@current_user.id == @order.user_id or @current_user.admin?)
  end

  def create?
    @current_user.present? and (@current_user.id == @order.user_id or @current_user.admin?)
  end

  def index?
    @current_user.present?
  end

  def manage?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def show?
    @current_user.present? and (@current_user.id == @order.user_id or @current_user.admin? or @current_user.seller?)
  end

  # only for dashboard

  def edit?
    @current_user.present? and @current_user.admin?
  end

  def destroy?
    @current_user.present? and @current_user.admin?
  end
end