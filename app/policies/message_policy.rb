class MessagePolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @message = model
  end

  def index?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def new?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  def create?
    @current_user.present? and (@current_user.admin? or @current_user.seller?)
  end

  # only for dashboard

  def show?
    @current_user.present? and @current_user.admin?
  end

  def edit?
    @current_user.present? and @current_user.admin?
  end

  def destroy?
    @current_user.present? and @current_user.admin?
  end
end