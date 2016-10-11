class AddRandomToOrders < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.integer :identification_no, :limit => 5, :null => false, :default => 12345
    end
  end
  
  def down
    remove_column :orders, :identification_no
  end
end
