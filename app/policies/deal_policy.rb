class DealPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @deal = model
  end

  def index?
    true
  end

  def new?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def edit?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def manage?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def create?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def update?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def destroy?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end
end