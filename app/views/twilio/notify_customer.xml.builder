xml.instruct!
xml.Response do
  xml.Say "Your order from #{@order.restaurant_name} will be #{@ready_or_deliver} in #{@the_wait} minutes.", :loop => 2
  xml.Say "Goodbye."
  xml.Hangup
end
