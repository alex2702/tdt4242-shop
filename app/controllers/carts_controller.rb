class CartsController < ApplicationController
  include ProductItemsHelper

  # create a new cart instance
  def new
    authorize Cart
    @cart = Cart.new
  end

  # restful action for creating a new cart instance
  def create
    # create a new cart
    @cart = Cart.new

    # add the user's ID to the new cart
    @cart.user_id = params['user_id']

    authorize @cart

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # gather required information to display a cart instance
  def show
    @cart = Cart.find_by(user_id: current_user.id)
    authorize @cart
    @total_amount, @total_discount, @discounts = calculate_total_amount(@cart.cart_items)
  end
end
