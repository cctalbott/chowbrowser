class AddDeliveryFieldsToCart < ActiveRecord::Migration
  def change
    change_table :carts do |t|
      t.integer :delivery_distance, :limit => 5
      t.integer :delivery_duration, :limit => 4
      t.references :delivery_address
    end
    @delivery_addresses = DeliveryAddress.select("id, order_id")
    @delivery_addresses.each do |delivery_address|
      begin
        order = Order.find(delivery_address.order_id)
        if order.cart
          order.cart.update_attribute(:delivery_address_id, delivery_address.id)
        end
      rescue
        delivery_address.destroy
      end
    end
  end
end
