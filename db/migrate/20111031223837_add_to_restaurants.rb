class AddToRestaurants < ActiveRecord::Migration
  def change
    change_table :restaurants do |t|
      t.string :description, :limit => 500
      t.float :ordermin, :limit => 4
      t.float :ordermax, :limit => 6
      t.boolean :featured
    end
  end
end
