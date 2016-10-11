module CartsHelper
  def is_in_cart?(line_item = nil)
    if line_item
      for line_item_option in line_item.line_item_options.each do
        if line_item_option.menu_item_option
          in_cart = true
        else
          in_cart = false
        end
      end
    else
      in_cart = false
    end
    
    return in_cart
  end
end