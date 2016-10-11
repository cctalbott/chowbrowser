module Admin::BatchesHelper
  def restaurant_name(location_id)
    Restaurant.joins(:locations).where("locations.id = ?", location_id).first.name
  end

  def combined_subtotal(orders)
    total = 0.0
    orders.each do |order|
      total += order.subtotal
    end
    return total
  end

  def combined_total(orders)
    total = 0.0
    orders.each do |order|
      total += order.grand_total
    end
    return total
  end

  def combined_delivery_fee(orders)
    total = 0.0
    orders.each do |order|
      total += order.delivery_fee.is_a?(Numeric) ? order.delivery_fee : 0.0
    end
    return total
  end

  def combined_tip(orders)
    total = 0.0
    orders.each do |order|
      total += order.tip.is_a?(Numeric) ? order.tip : 0.0
    end
    return total
  end

  def combined_restaurant_deposit(orders)
    total = 0.0
    orders.each do |order|
      total += order.restaurant_deposit
    end
    return total
  end

  def combined_driver_deposit(orders)
    total = 0.0
    orders.each do |order|
      total += order.driver_deposit.is_a?(Numeric) ? order.driver_deposit : 0.0
    end
    return total
  end

  def combined_chowbrowser_deposit(orders)
    total = 0.0
    orders.each do |order|
      total += order.chowbrowser_deposit
    end
    return total
  end

  def combined_assoc_deposit(orders)
    total = 0.0
    orders.each do |order|
      total += order.assoc_deposit
    end
    return total
  end

  def combined_sales_deposit(orders)
    total = 0.0
    orders.each do |order|
      total += order.sales_deposit
    end
    return total
  end


  def combined_corp_deposit(orders)
    total = combined_chowbrowser_deposit(orders) - combined_assoc_deposit(orders) - combined_sales_deposit(orders)
    return total
  end
end
