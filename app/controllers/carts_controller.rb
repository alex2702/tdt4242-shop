class CartsController < ApplicationController
  def new
    @cart = Cart.new
    authorize @cart
  end

  def create
    # create a new cart
    @cart = Cart.new

    # add the user's ID to the new cart
    @cart.user_id = params['user_id']

    authorize @cart

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @cart = Cart.find_by(user_id: current_user.id)
    authorize @cart
    @total_amount, @total_discount, @discounts = calculate_total_amount
  end

  private

  def calculate_total_amount
    # retrieve base data
    cart = Cart.find_by(user_id: current_user.id)
    deals = Deal.all.includes(:product)

    # return elements
    total_amount = 0
    discount_amount = 0
    discounts = Array.new

    # calculation
    cart.cart_items.each do |cart_item|
      # calculate initial total amount (without deals)
      total_amount += cart_item.amount * cart_item.product.price

      # check all deals for this product
      deals.each do |deal|
        if deal.product_id == cart_item.product_id
          # check for volume-based deals and if trigger amount is reached
          multiplier = 0
          if deal.type == 'VolumeDeal'
            if deal.trigger_amount.present? and cart_item.amount >= deal.deal_amount
              multiplier = cart_item.amount / deal.deal_amount
              discount_amount += multiplier * cart_item.product.price
              discount = {
                  deal_id: deal.id,
                  deal_multiplier: multiplier
              }
              discounts.push(discount)
            end
          end

          # check for percentage-based deals
          if deal.type == 'PercentageDeal'
            discount_amount += (cart_item.amount - multiplier) * cart_item.product.price * deal.discount_percentage
            discount = {
                deal_id: deal.id,
                deal_multiplier: cart_item.amount
            }
            discounts.push(discount)
          end
        end
      end
    end
    return total_amount, discount_amount, discounts
  end
end
