class AddPercentToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.integer :percentage, :limit => 3, :null => false, :default => 90
    end
    ls = Location.all
    ls.each do |l|
      l.update_attribute(:percentage, 90)
    end
  end
end
