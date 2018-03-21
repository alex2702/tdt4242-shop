class CartItemsController < ApplicationController
  def new
    authorize CartItem
    @cart_item = CartItem.new
  end

  # DELETE /cart_item/1
  def destroy
    @cart_item = CartItem.find(params[:id])
    authorize @cart_item
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to '/cart', notice: 'The item was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def add_to_cart
    @cart = current_user.cart
    authorize @cart

    if @cart.cart_items.where(product_id: params[:cart_item][:product]).count.positive?
      @cart_item = @cart.cart_items.where(product_id: params[:cart_item][:product]).first
      @cart_item.amount += params[:cart_item][:amount].to_i
    else
      @cart_item = CartItem.new(cart_id: @cart.id, product_id: params[:cart_item][:product], amount: params[:cart_item][:amount])
    end

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to @cart, notice: 'The item was added to your cart.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        format.js   { render :add_to_cart, content_type: 'text/javascript' }
      end
    end
  end

  # PATCH/PUT /cart_items/1
  def update
    @cart_item = CartItem.find(params[:id])
    authorize @cart_item
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to '/cart', notice: "The amount of #{@cart_item.product.name.pluralize(@cart_item.amount)} was successfully updated." }
        format.json { render :edit_amount, status: :ok, location: @cart_item }
      else
        format.html { render :edit_amount }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  private

  # Only allow the whitelisted parameters.
  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :product_id, :amount)
  end
end