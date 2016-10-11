module Public::OrdersHelper
  def no_records
    status = "There are no previous records for this "
    if params[:day] != "all"
      status += "day"
    elsif params[:month] != "all"
      status += "month"
    elsif params[:year] != "all"
      status += "year"
    else
      status = "There are no previous records"
    end
    status += "."
    return status
  end

  def sub_total(order)
    return order.subtotal
=begin
    total_price = 0.0
    order.cart.line_items.each do |line_item|
      total_price += line_item.menu_section_item.price.to_f
      if line_item.line_item_options
        line_item.line_item_options.each do |line_item_option|
          total_price += (line_item_option.price.to_f * line_item_option.qty.to_f).to_f
        end
      end
    end
    return total_price
=end
  end

  def tax(order)
    sub_total(order) * 0.0825
  end

  def tip(order)
    order.cart.tip
  end

  def total(order)
    if order.cart.delivers && order.cart.tip
      sub_total(order) + tax(order) + tip(order)
    else
      sub_total(order) + tax(order)
    end
  end

  def monthly_total(orders)
    monthly_total = 0.0
    orders.each do |order|
      monthly_total += total(order)
    end
    return monthly_total
  end

  def line_item_total(line_item)
    if !line_item.unit_price.blank?
      total = line_item.unit_price.to_f
    elsif
      total = line_item.menu_section_item.price.to_f
    else
      total = 0
    end
    if line_item.line_item_options && line_item.line_item_options.count > 0
      line_item.line_item_options.each do |line_item_option|
        total += (line_item_option.price.to_f * line_item_option.qty.to_f).to_f
      end
    end
    tax = total * 0.0825
    total = total + tax
    return total
  end

  def line_item_sub_total(line_item)
    if !line_item.unit_price.blank?
      total = line_item.unit_price.to_f
    elsif
      total = line_item.menu_section_item.price.to_f
    else
      total = 0
    end
    if line_item.line_item_options && line_item.line_item_options.count > 0
      line_item.line_item_options.each do |line_item_option|
        total += (line_item_option.price.to_f * line_item_option.qty.to_f).to_f
      end
    end
    return total
  end

  def total_by_selector(orders)
    total = 0.0
    orders.each do |order|
=begin
      order.cart.line_items.each do |line_item|
        begin
          total += line_item.menu_section_item.price.to_f
          if line_item.line_item_options
            line_item.line_item_options.each do |line_item_option|
              total += (line_item_option.menu_item_option.price.to_f * line_item_option.qty.to_f).to_f
            end
          end
        rescue ActionView::Template::Error
          # order and cart issues
        end
      end
=end
      total += total(order)
    end
    #tax = total * 0.0825
    #total = tax + total
    return total
  end

  def month_count(orders)
    return orders.length
  end

  def month_average(orders)
    order_count = month_count(orders)
    order_total = total_by_selector(orders)
    month_avg = order_total/order_count
    return month_avg
  end

  def monthly_orders_restaurants(orders)
    orders.group_by { |o| o.restaurant_name }
  end

  def monthly_restaurant_orders_customers(orders)
    orders.group_by { |o| o.email }
  end

  def monthly_customer_orders_restaurants(orders)
    #orders.group_by { |o| o.restaurant_name }
    orders.group_by { |o| o.restaurant_name }
  end

  def month_count_by_selector(orders, selector)
    orders = orders.select { |k, v| v = selector }
    order_count = orders.count
    return order_count
  end

  def month_total_by_selector(orders, selector)
    orders = orders.select { |k, v| v = selector }
    month_total = total_by_selector(orders)
    return month_total
  end

  def month_average_by_selector(orders, selector)
    orders = orders.select { |k, v| v = selector }
    order_count = month_count_by_selector(orders, selector)
    order_total = month_total_by_selector(orders, selector)
    month_avg = order_total/order_count
    return month_avg
  end

  def csv_string(orders)
    require "csv"
    CSV.generate do |csv|
      case @category
      when "restaurant"
        csv << [" ", "Count: #{month_count(@orders)}", "Avg: #{number_to_currency(month_average(@orders))}", "Total: #{number_to_currency(total_by_selector(@orders))}"]
        csv << %w[RESTAURANT # AVG TOTAL]
        monthly_orders_restaurants(orders).each do |restaurant, orders|
          csv << [restaurant, month_count(orders), number_to_currency(month_average(orders)), number_to_currency(monthly_total(orders))]
        end
      when "customer"
        csv << [" ", "Count: #{month_count(@orders)}", "Avg: #{number_to_currency(month_average(@orders))}", "Total: #{number_to_currency(total_by_selector(@orders))}"]
        csv << %w[CUSTOMER # AVG TOTAL]
        monthly_restaurant_orders_customers(orders).each do |customer, orders|
          csv << [customer, month_count(orders), number_to_currency(month_average(orders)), number_to_currency(monthly_total(orders))]
        end
      else
        csv << [" ", " ", "Count: #{month_count(@orders)}", "Avg: #{number_to_currency(month_average(@orders))}", "Total: #{number_to_currency(total_by_selector(@orders))}"]
        csv << %w[ID RESTAURANT CUSTOMER DAY/TIME TOTAL]
        orders.each do |order|
          csv << [order.id, order.restaurant_name, order.email, order.purchased_at.strftime("%Y %b %a %l:%M%p %Z"), number_to_currency(order.price)]
        end
      end
    end
  end

  def restaurant_csv_string(orders)
    require "csv"
    CSV.generate do |csv|
      csv << [" ", "Count: #{month_count(@orders)}", "Avg: #{number_to_currency(month_average(@orders))}", "Total: #{number_to_currency(total_by_selector(@orders))}"]
      csv << %w[ID CUSTOMER DAY/TIME TOTAL]
      @orders.each do |order|
        csv << [order.id, order.email, order.purchased_at.strftime("%Y %b %a %l:%M%p %Z"), number_to_currency(total(order))]
      end
    end
  end

  def customer_csv_string(orders)
    require "csv"
    CSV.generate do |csv|
      csv << [" ", "Count: #{month_count(@orders)}", "Avg: #{number_to_currency(month_average(@orders))}", "Total: #{number_to_currency(total_by_selector(@orders))}"]
      csv << %w[ID RESTAURANT DAY/TIME TOTAL]
      @orders.each do |order|
        csv << [order.id, order.restaurant_name, order.purchased_at.strftime("%Y %b %a %l:%M%p %Z"), number_to_currency(total(order))]
      end
    end
  end

  def show_csv_string(order)
    require "csv"
    CSV.generate do |csv|
      csv << ["Order:", @order.id]
      csv << ["Placed:", @order.created_at.strftime('%a, %d %b %Y %I:%S%p %Z')]
      csv << ["Restaurant:", @order.restaurant_name]
      csv << ["Location:", @order.location_address]
      csv << %w[ITEM PRICE]
      order.cart.line_items.each do |line_item|
        csv << [line_item.menu_section_item.name, number_to_currency(line_item_total(line_item))]
      end
      csv << ["Sub Total:", number_to_currency(sub_total(@order))]
      csv << ["Tax:", number_to_currency(tax(@order))]
      if @order.cart.delivers && @order.cart.tip
        csv << ["Tip:", number_to_currency(tip(@order))]
      end
      csv << ["Grand Total:", number_to_currency(total(@order))]
    end
  end
=begin
  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
=end
end
