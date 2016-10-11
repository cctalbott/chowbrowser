xml.instruct!
xml.Response do
  xml.Gather(:action => @postto, :numDigits => 1) do
    xml.Say "#{@order.billing_address.first_name} #{@order.billing_address.last_name} has placed an order to your restaurant through Chow Browser."
    #xml.Say "Order consist of:"
    #@order.cart.line_items.each do |line_item|
    #  xml.Say "#{line_item.menu_section_item.name}"
    #end
    xml.Say "Please press 1 to confirm order.", :loop => 3
  end
end
