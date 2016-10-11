class AddLineItemOptions < ActiveRecord::Migration
  def up
    create_table :carts do |t|
      t.datetime :purchased_at
      
      t.timestamps
    end
    
    create_table :line_items do |t|
      t.decimal :unit_price
      t.references :menu_section_item
      t.references :cart
      t.integer :quantity
      
      t.timestamps
    end
    
    create_table :orders do |t|
      t.references :cart
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      
      t.timestamps
    end
    
    create_table :order_transactions do |t|
      t.references :order
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
    
    change_table :menus do |t|
      t.integer :order, :limit => 2
    end
    
    @menu = Menu.all
    @menu.each { |f| f.update_attributes!(:restaurant_id => f.restaurant.locations[0].id.to_i) }
    
    rename_column :menus, :restaurant_id, :location_id
    
    create_table :menu_item_options do |t|
      t.string :name
      t.float :price, :limit => 4
      t.integer :position, :limit => 2
      t.references :menu_section_item
      
      t.timestamps
    end
    
    create_table :line_item_options, :id => false do |t|
      t.references :line_item, :menu_item_option
      
      t.timestamps
    end
  end

  def down
    drop_table :line_item_options
    
    drop_table :menu_item_options
    
    @menu = Menu.all
    @menu.each { |f| f.update_attributes!(:location_id => f.restaurant.restaurant.id.to_i) }
    
    rename_column :menus, :location_id, :restaurant_id
    remove_column :menus, :order
    
    drop_table :carts
    drop_table :line_items
    drop_table :orders
    drop_table :order_transactions
  end
end
