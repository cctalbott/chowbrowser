class AddSalesOffices < ActiveRecord::Migration
  def up
    create_table :sales_offices do |t|
      t.string :name, :limit => 150, :null => false
      t.string :location, :limit => 150, :default => nil

      t.timestamps
    end
    change_table :locations do |t|
      t.references :sales_office
    end
  end

  def down
    remove_column :locations, :sales_office_id
    drop_table :sales_offices
  end
end
