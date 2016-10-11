class AddCallStatuses < ActiveRecord::Migration
  def up
    remove_column :locations, :delivers

    create_table :delivery_addresses do |t|
      t.string :address, :limit => 250
      t.string :city, :limit => 250
      t.string :state, :limit => 250
      t.string :country, :limit => 250
      t.string :zip, :limit => 100
      t.references :order
      t.timestamps
    end
    remove_column :orders, :first_name
    remove_column :orders, :last_name
    remove_column :orders, :address

    create_table :delivery_drivers do |t|
      t.string :phone, :limit => 50, :default => nil
      t.references :user
      t.timestamps
    end

    create_table :delivery_drivers_locations, :id => false do |t|
      t.references :delivery_driver
      t.references :location
    end

    remove_column :billing_addresses, :name
    add_column :billing_addresses, :first_name, :string, :limit => 125
    add_column :billing_addresses, :last_name, :string, :limit => 125

    create_table :printers do |t|
      t.string :model_name, :limit => 140
      t.string :service_no, :limit => 140
      t.string :email, :limit => 140
      t.references :location
      t.timestamps
    end

    add_column :locations, :email, :string, :limit => 140
    add_column :locations, :active, :boolean, :default => true

    locations = Location.all
    locations.each do |location|
      location.update_attribute(:active, false)
    end

    change_column :menu_section_items, :featured, :boolean, :default => false

    create_table :call_statuses do |t|
      t.string :call_sid, :limit => 100
      t.string :status, :limit => 50
      t.timestamps
    end

    create_table :call_statuses_orders, :id => false do |t|
      t.references :call_status
      t.references :order
    end
  end

  def down
    drop_table :call_statuses_orders
    drop_table :call_statuses

    remove_column :locations, :active
    remove_column :locations, :email
    drop_table :printers

    add_column :billing_addresses, :name, :string, :limit => 250
    remove_column :billing_addresses, :first_name
    remove_column :billing_addresses, :last_name

    drop_table :delivery_drivers
    drop_table :delivery_drivers_locations

    drop_table :delivery_addresses

    add_column :locations, :delivers, :boolean, :default => false
  end
end
