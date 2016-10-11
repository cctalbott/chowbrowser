class AddFeaturedToItems < ActiveRecord::Migration
  def change
    change_table :menu_section_items do |t|
      t.boolean :featured
    end
  end
end
