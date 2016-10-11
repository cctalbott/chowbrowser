class AddOptionRelationships < ActiveRecord::Migration
  def up
    create_table :option_relationships, :id => false do |t|
      t.references :item_option_section
      t.references :menu_section_item
      t.references :menu_section
    end

    @ios = ItemOptionSection.all
    @ios.each do |io|
      option_relationship = OptionRelationship.new({
        :item_option_section_id => io.id,
        :menu_section_item_id => io.menu_section_item_id
      })
      option_relationship.save
    end
  end

  def down
    drop_table :option_relationships
  end
end
