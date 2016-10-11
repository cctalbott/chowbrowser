class AddRestaurantNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :restaurant_name, :string

    @orders = Order.location_join.readonly(false)
    @orders.each { |order| order.update_attribute(:restaurant_name, order.restaurant.name) }
  end
end
