class ProductsController < ApplicationController
  after_action :verify_authorized

  # GET /products
  def index
    authorize Product

    @all_brands = Product.distinct.pluck(:brand)
    @all_materials = Product.distinct.pluck(:material)

    # create a list of all the products to be displayed by the in html file, after filtering it based on the query params in the URL
    # params are filtered after "(brandX OR brandY) AND (materialA OR materialB) AND lprice AND hprice" logic
    
    @products = Product.all
    
    if params[:brand] != nil
      @products = @products.where(brand: params[:brand].split('_'))
    end
    if params[:material] != nil
      @products = @products.where(material: params[:material].split('_'))
    end
    if priceStringToInt(params[:lprice]) != nil
      @products = @products.where("price >= ?", priceStringToInt(params[:lprice]))
    end
    if priceStringToInt(params[:hprice]) != nil
      @products = @products.where("price <= ?", priceStringToInt(params[:hprice]))
    end
    #This might be vulnerable to SQL injection, might need to use sanitize_sql_like
    if params[:search] != nil
      @products = @products.where("name LIKE ? or description LIKE ?", "%"+params[:search]+"%", "%"+params[:search]+"%")
    end
  end

  # GET /products/manage
  # action for product management area that retrieves all product instances
  def manage
    authorize Product
    @products = Product.all
  end

  # GET /products/1
  # get product instance with given ID
  def show
    authorize Product
    @product = Product.find(params[:id])
  end

  # GET /products/new
  # restful action for creating a new product instance
  def new
    authorize Product
    @product = Product.new
  end

  # GET /products/1/edit
  # restful action for editing existing product instances
  def edit
    authorize Product
    @product = Product.find(params[:id])
  end

  # POST /products
  # creating a new product instance from given paramters
  def create
    authorize Product
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'The product has been created successfully.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.js   { render :new, content_type: 'text/javascript' }
      end
    end
  end

  # PATCH/PUT /products/1
  # general update endpoint for product instances
  def update
    authorize Product
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'The product was successfully updated.' }
        format.json { render json: @product, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.js   { render :edit, content_type: 'text/javascript' }
      end
    end
  end

  # special method to only update the stock level of a product
  # necessary because we have a special form with only one field (the stock level)
  def update_stock
    authorize Product
    @product = Product.find(params[:product][:id])
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to manage_products_path, notice: "The stock level of #{@product.name} was successfully updated." }
        format.json { render json: @product, status: :ok, location: @product }
      else
        format.html { render :manage }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /products/1
  # destroy the product instance with the given id
  def destroy
    authorize Product
    @product = Product.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.html { redirect_to manage_products_path, notice: 'The product was successfully removed.' }
      format.json { head :no_content, status: :ok }
    end
  end

  private

  # Only allow the whitelisted parameters.
  def product_params
    params.require(:product).permit(:name, :description, :stock_level, :price, :brand, :material, :weight)
  end

  # used for search, convert string to int
  def priceStringToInt(param_string)
    num = param_string.to_i
    num if num.to_s == param_string && num >= 0
  end

  # used for search, check for matching search term
  def notMatchingSearchTerm(term, product)
    if product.name.downcase.include? term.downcase
      return false
    end
    if product.description.downcase.include? term.downcase
      return false
    end
    return true 
  end 
  
end
