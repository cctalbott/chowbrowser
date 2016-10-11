class AddLatlongLocations < ActiveRecord::Migration
  def up
    change_column :orders, :estimated_wait, :integer, :default => 30
    change_table :orders do |t|
      t.references :user
    end

    add_column :carts, :tip, :decimal

    add_column :locations, :lat, :float, :limit => 11
    add_column :locations, :lon, :float, :limit => 11
  end

  def down
    remove_column :locations, :lat
    remove_column :locations, :lon

    remove_column :carts, :tip

    remove_column :orders, :user_id
    change_column :orders, :estimated_wait, :integer, :default => nil
  end
end
