require 'spec_helper'

describe "Line Items" do
  menu_section_item = FactoryGirl.create(:menu_section_item)

  describe "GET /public/line_items/new?item=#{menu_section_item.id}" do
    it "NEW line item" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get new_public_line_item_path(:item => menu_section_item.id)
      response.status.should be(200)
    end
  end

  describe "POST /public/line_items/new?item=#{menu_section_item.id}" do
    it "POST to cart" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      post public_line_items_path(:item => menu_section_item.id, :method => :post)
      response.status.should be(302)
    end
  end
end
