class AddNameToMenu < ActiveRecord::Migration
  def up
    create_table :restaurants do |t|
      t.string :name

      t.timestamps
    end

    create_table :locations do |t|
      t.string :address
      t.references :restaurant

      t.timestamps
    end
    add_index :locations, :restaurant_id

    create_table :menus do |t|
      t.references :restaurant

      t.timestamps
    end
    add_index :menus, :restaurant_id

    create_table :menu_sections do |t|
      t.string :name
      t.references :menu

      t.timestamps
    end
    add_index :menu_sections, :menu_id

    create_table :menu_section_items do |t|
      t.string :name, :limit => 200
      t.string :description, :limit => 500
      t.float :price, :limit => 5
      t.references :menu_section

      t.timestamps
    end
    add_index :menu_section_items, :menu_section_id

    add_column :menus, :name, :string, :limit => 150
  end

  def down
    drop_table :menu_section_items
    drop_table :menu_sections
    drop_table :menus
    drop_table :locations
    drop_table :restaurants
  end
end
