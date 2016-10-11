xml.instruct!
xml.Response do
  xml.Gather(:action => @postto, :numDigits => 1) do
    xml.Say "#{@order.billing_address.first_name} #{@order.billing_address.last_name} has placed an order to your restaurant through Chow Browser."
    xml.Say "Order consist of:"
    @order.cart.line_items.each do |line_item|
      xml.Say "#{line_item.quantity}"
      xml.Say "#{line_item.menu_section_item.name}"
      if line_item.menu_item_options
        line_item.menu_item_options.each do |menu_item_option|
          xml.Say "#{menu_item_option.name}"
        end
      end
      if line_item.instructions
        xml.Say "#{line_item.instructions}"
      end
    end
    xml.Say "Press 1 to confirm order. Press 2 to repeat order. You may check your restaurants email or text message if available as well for the order.", :loop => 3
  end
end
