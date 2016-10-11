class AddStateCityToLocation < ActiveRecord::Migration
  def change
    change_table :menu_section_items do |t|
      t.references :restaurant
      t.integer :order, :limit => 2, :default => 0
    end
    
    change_table :menu_sections do |t|
      t.integer :order, :limit => 2, :default => 0
    end
    
    change_table :menu_sections do |t|
      t.rename :order, :position
    end
    
    change_table :menu_section_items do |t|
      t.rename :order, :position
    end
    
    change_table :locations do |t|
      t.string :region, :limit => 100
      t.string :city, :limit => 150
      t.string :postal_code, :limit => 50
    end
  end
end
