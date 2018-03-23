module ProductItemsHelper

  # calculates the total amount of a collection of product_items (either order_items or cart_items)
  def calculate_total_amount(product_items)
    # return elements
    total_amount = 0
    discount_amount = 0
    discounts = Array.new

    # apply deals to each item
    product_items.each do |product_item|
      discount_a, discs = apply_deals(product_item)
      total_amount += product_item.amount * product_item.product.price
      discount_amount += discount_a
      discounts += discs
    end

    logger.debug "Returning total_amount #{total_amount}, discount_amount #{discount_amount}, discounts #{discounts.inspect}"
    return total_amount, discount_amount, discounts
  end

  # apply all current deals to a given collection of product items
  # return the total amount, the discount amount and a list of all discounts applied for this product
  def apply_deals(product_item)
    # set some default variables
    discount_amount = 0
    discounts = Array.new
    multiplier = 0

    volume_deals = Deal.where(type: 'VolumeDeal')

    volume_deals.each do |deal|
      if deal.product_id == product_item.product_id
        # check for volume-based deals and if trigger amount is reached
        # check if deal applies due to large enough amount
        next unless deal.trigger_amount.present? and product_item.amount >= deal.deal_amount
        # then see how many times deal applies and save discount to array
        multiplier = product_item.amount / deal.deal_amount
        logger.debug "Deal applies #{multiplier}"
        discount_amount += multiplier * product_item.product.price
        discount = {
            deal_id: deal.id,
            deal_multiplier: multiplier
        }
        discounts.push(discount)
        # since we only allow one volume deal for each product, break out of the loop
        break
      else
        multiplier = 0
      end
    end
    
    percentage_deals = Deal.where(type: 'PercentageDeal')
  
    percentage_deals.each do |deal|
      next unless deal.product_id == product_item.product_id
      discount_amount += (product_item.amount - multiplier) * product_item.product.price * deal.discount_percentage
      discount = {
          deal_id: deal.id,
          deal_multiplier: product_item.amount - multiplier
      }
      discounts.push(discount)
      # since we only allow one percentage deal for each product, break out of the loop
      break
    end

    return discount_amount, discounts
  end
end
