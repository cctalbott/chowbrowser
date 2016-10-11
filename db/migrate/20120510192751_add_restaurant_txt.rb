class AddRestaurantTxt < ActiveRecord::Migration
  def up
    remove_column :order_transactions, :message
    add_column :order_transactions, :message, :text

    create_table :clock_in do |t|
      t.references :user
      t.timestamps
    end

    create_table :logos do |t|
      t.string :img_path, :null => false, :default => "/logos/default.png"
      t.references :restaurant
      t.timestamps
    end
    add_column :item_option_sections, :multiple_limit, :integer, :limit => 2

    create_table :sales_people do |t|
      t.references :user
      t.timestamps
    end
    change_table :locations do |t|
      t.references :sales_person
    end

    change_table :locations do |t|
      t.boolean :recite_order, :default => false
      t.string :txt_no, :limit => 50, :default => nil
    end
  end

  def down
    remove_column :locations, :txt_no
    remove_column :locations, :recite_order

    remove_column :locations, :sales_person_id
    drop_table :sales_people

    remove_column :item_option_sections, :multiple_limit
    drop_table :logos

    drop_table :clock_in

    remove_column :order_transactions, :message
    add_column :order_transactions, :message, :string
  end
end
