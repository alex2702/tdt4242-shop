class ProductsController < ApplicationController
  after_action :verify_authorized

  # GET /products
  def index
    authorize Product
    all_products = Product.all

    # create two arrays with all the unique brand and material names that are used by the template products/index.html.erb to create html checkboxes
    # the lists are also used by this function to filter products based on query params in the URL
    @all_brands = Product.distinct.pluck(:brand)
    @all_materials = Product.distinct.pluck(:material)

    # create a list of all the products to be displayed by the in html file, after filtering it based on the query params in the URL
    # params are filtered after "(brandX OR brandY) AND (materialA OR materialB) AND lprice AND hprice" logic
    @products = Array.new
    all_products.each do |product|
      add = true
      if params[:brand] != nil
        add = false
        brand_filter = paramsToList(params[:brand])
        brand_filter.each do |brandNum|
          if product.brand == @all_brands[brandNum]
            add = true
            break
          end
        end
      end
      if params[:material] != nil && add
        add = false
        material_filter = paramsToList(params[:material])
        material_filter.each do |matNum|
          if product.material == @all_materials[matNum]
            add = true
            break
          end
        end
      end
      if params[:lprice] != nil && priceStringToInt(params[:lprice]) != nil && priceStringToInt(params[:lprice]) > product.price
        add = false
      end 
      if params[:hprice] != nil && priceStringToInt(params[:lprice]) != nil && priceStringToInt(params[:hprice]) < product.price
        add = false
      end
      if params[:search] != nil && notMatchingSearchTerm(params[:search], product)
        add = false
      end
      if add
        @products.insert(-1, product)
      end
    end
  end

  # GET /products/manage
  def manage
    authorize Product
    @products = Product.all
  end

  # GET /products/1
  def show
    authorize Product
    @product = Product.find(params[:id])
  end

  # GET /products/new
  def new
    authorize Product
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    authorize Product
    @product = Product.find(params[:id])
  end

  # POST /products
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
  
  def paramsToList(param_string)
    paramIntList = Array.new
    paramStringList = param_string.split('_')
    paramStringList.each do |ps|
      paramInt = priceStringToInt(ps[1..-1])
      if paramInt != nil
        paramIntList.insert(-1, paramInt)
      end
    end
    paramIntList
  end
  
  def priceStringToInt(param_string)
    num = param_string.to_i
    num if num.to_s == param_string && num >= 0
  end
  
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
