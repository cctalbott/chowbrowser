class AddDeliversToCart < ActiveRecord::Migration
  def change
    change_table :carts do |t|
      t.boolean :delivers, :default => false
    end
  end
end
