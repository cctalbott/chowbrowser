class AddDeliveryHours < ActiveRecord::Migration
  def up
    create_table :delivery_hours do |t|
      t.integer :day, :limit => 1
      t.integer :start_hr, :limit => 2
      t.integer :start_min, :limit => 2
      t.integer :end_hr, :limit => 2
      t.integer :end_min, :limit => 2
      t.references :delivery_driver
      t.timestamps
    end
  end

  def down
    drop_table :delivery_hours
  end
end
