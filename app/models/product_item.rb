class ProductItem < ApplicationRecord
  belongs_to :product
  validate :product_in_stock
  #TODO validate that number is above 0

  def product_in_stock
    logger.debug "Stock level is #{Product.find(product_id).stock_level}"
    logger.debug "Amount asked for is #{amount}"
    stock_level = Product.find(product_id).stock_level
    errors.add(:amount, " – We do not have enough items in stock: #{amount} items requested, #{stock_level} items in stock.") unless
        amount <= stock_level
  end
end
