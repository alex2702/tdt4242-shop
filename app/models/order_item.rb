class OrderItem < ProductItem
  belongs_to :order
  # we do validate this in product_item, however when transforming an item into an ORDER_item, we have to validate AGAIN
  validate :product_in_stock
end
