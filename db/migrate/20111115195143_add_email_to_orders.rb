class AddEmailToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :email, :string
    
    create_table :item_option_sections do |t|
      t.string :name
      t.integer :position, :limit => 2
      t.references :menu_section_item
    end
    
    change_table :menu_item_options do |t|
      t.references :item_option_section
    end
  end
  
  def down
    remove_column :menu_item_options, :item_option_section_id   
    destroy_table :item_option_sections
    remove_column :orders, :email
  end
end
