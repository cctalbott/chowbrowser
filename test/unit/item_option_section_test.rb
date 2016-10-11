require 'test_helper'

class ItemOptionSectionTest < ActiveSupport::TestCase
  test "should not save item option section without name" do
    item_option_section = ItemOptionSection.new
    assert !item_option_section.save
  end

  test "should not save item option section with name less than 1 character" do
    item_option_section = ItemOptionSection.new(:name => "")
    assert !item_option_section.save
  end

  test "should save item option section with valid date" do
    item_option_section = ItemOptionSection.new(:name => "Size")
    assert item_option_section.save
  end
end
