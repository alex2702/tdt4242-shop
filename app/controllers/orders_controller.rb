class OrdersController < ApplicationController
  include ProductItemsHelper

  def new
    authorize Order
    @order = Order.new
  end

  def checkout
    @order = Order.new
    @cart = Cart.find_by(user_id: current_user.id)
    authorize @cart
    @total_amount, @total_discount, @discounts = calculate_total_amount(@cart.cart_items)
  end

  def create
    # create new order object from form parameters
    @order = Order.new(order_params)

    # get the contents of the cart
    @cart = Cart.find(current_user.cart_id)

    # for security reasons, calculate the total amount from the actual cart (instead of taking a parameter)
    @total_amount, @total_discount, @discounts = calculate_total_amount(@cart.cart_items)
    @order.total_amount = @total_amount

    authorize @order

    # check if there is enough stock of all items to be ordered
    # if not, respond with error
    # if yes, go on
    # note: we can't do this in the transaction because it's a different model (CartItem, not Order)
    @cart.cart_items.each do |cart_item|
      if cart_item.product.stock_level < cart_item.amount
        @order.errors.add(:base, "We do not have enough items of #{cart_item.product.name} left: #{cart_item.amount} requested, #{cart_item.product.stock_level} in stock.")
        respond_to do |format|
          format.html { render :checkout }
          format.json { render json: @order.errors, status: :unprocessable_entity }
          format.js   { render :checkout, content_type: 'text/javascript' }
        end
        return
      end
    end

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          # save order object without running validations yet, so we get the object ID
          # validations will be run below
          @order.save!(:validate => false)
          # create order_items out of all cart_items
          # decrease stock level of all cart_items by amount ordered
          # it's no problem if we encounter a problem at one of the latter cart_items because the transaction will
          # roll back completely in case of failure
          @cart.cart_items.each do |cart_item|
            cart_item.becomes!(OrderItem)
            cart_item.update!(order_id: @order.id, cart_id: nil)
            cart_item.product.stock_level -= cart_item.amount
            cart_item.product.save!
          end
          StatusMailer.status_update(@order.user_id, @order.id, "We have received your order", "Your order was received. Please note that this is not an order confirmation. You will receive a confirmation shortly.").deliver
          # final save so all validations are run
          @order.save!
          format.html { redirect_to @order, notice: 'Your order has been placed.' }
          format.json { render json: @order, status: :created, location: @order }
        rescue ActiveRecord::ActiveRecordError => e
          format.html { render :checkout }
          format.json { render json: @order.errors, status: :unprocessable_entity }
          format.js   { render :checkout, content_type: 'text/javascript' }
        end
      end
    end
  end

  def index
    authorize Order
    @orders = Order.where(user_id: current_user.id)
    @order_details = Array.new
    @orders.each do |order|
      @total_amount, @total_discount, @discounts = calculate_total_amount(order.order_items)
      @order_details[order.id] = {
          total_amount: @total_amount,
          total_discount: @total_discount,
          discounts: @discounts
      }
    end
  end

  def manage
    authorize Order
    @orders = Order.all
    @order_details = Array.new
    @orders.each do |order|
      @total_amount, @total_discount, @discounts = calculate_total_amount(order.order_items)
      @order_details[order.id] = {
          total_amount: @total_amount,
          total_discount: @total_discount,
          discounts: @discounts
      }
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
    @total_amount, @total_discount, @discounts = calculate_total_amount(@order.order_items)
  end

  private

  # Only allow the whitelisted parameters.
  def order_params
    params.require(:order).permit(:user_id, :credit_card_type, :credit_card_name, :credit_card_number,
                                  :credit_card_expiry, :credit_card_expiry_month, :credit_card_expiry_year,
                                  :credit_card_cvc
    )
  end
end
