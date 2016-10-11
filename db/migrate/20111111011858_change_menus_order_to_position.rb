class ChangeMenusOrderToPosition < ActiveRecord::Migration
  def change
    add_column :line_item_options, :id, :primary_key
    
    rename_column :menus, :order, :position
  end
end
