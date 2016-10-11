require 'spec_helper'

describe "Menus" do
  menu = FactoryGirl.create(:menu)

  describe "GET /public/menus/#{menu.id}" do
    it "should show menu" do
      get public_menu_path(menu.id)
      response.status.should be(200)
    end

    it "should not link to items on holidays" do
      menu_section_item = FactoryGirl.create(:menu_section_item)
      FactoryGirl.create_list(:holiday, 1, :location => menu_section_item.menu_section.menu.location)
      get public_menu_path(menu_section_item.menu_section.menu.id)
      response.status.should be(200)
      visit "/public/menus/#{menu_section_item.menu_section.menu.id}"
      page.should have_selector(".trigger .name_description h3", :text => "Brisket")
    end
  end
end
