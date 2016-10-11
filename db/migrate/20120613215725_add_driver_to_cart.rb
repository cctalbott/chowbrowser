class AddDriverToCart < ActiveRecord::Migration
  def change
    change_table :carts do |t|
      t.references :delivery_driver
      t.string :driver_email, :limit => 150
    end

    os = Order.joins(:cart).purchased.delivers
    os.each do |o|
      dd = o.location.delivery_drivers.first
      if dd
        begin
          os.cart.update_attributes({:delivery_driver_id => dd.id, :driver_email => dd.user.email})
        rescue
          # onward
        end
      end
    end
  end
end
