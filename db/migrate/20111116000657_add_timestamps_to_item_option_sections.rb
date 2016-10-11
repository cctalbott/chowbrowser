class AddTimestampsToItemOptionSections < ActiveRecord::Migration
  def change
    change_table :item_option_sections do |t|
      t.timestamps
    end
  end
end
