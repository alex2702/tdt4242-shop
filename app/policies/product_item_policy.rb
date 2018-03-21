class ProductItemPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @product_item = model
  end

  def new?
    @current_user.present? and @current_user.admin?
  end
end