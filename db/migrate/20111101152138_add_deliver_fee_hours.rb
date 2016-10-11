class AddDeliverFeeHours < ActiveRecord::Migration
  def up
    change_table :restaurants do |t|
      t.float :deliver_fee, :limit => 4
    end
    
    create_table :restaurant_hours do |t|
      t.string :sun, :mon, :tue, :wed, :thu, :fri, :sat, :limit => 50
      t.string :holidays, :limit => 250
      t.references :location
      
      t.timestamps
    end
  end
  
  def down
    drop_table :restaurant_hours
    remove_column :restaurants, :deliver_fee
  end
end
