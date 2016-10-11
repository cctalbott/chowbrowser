xml.instruct!
xml.Response do
  xml.Say "Your order has been confirmed by #{@order.restaurant_name}."
  xml.Redirect @redirectto
end
