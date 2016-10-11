require 'spec_helper'

describe "Carts" do
  describe "GET /cart" do
    cart = FactoryGirl.create(:cart)

    it "GET cart" do
      get current_cart_path
      response.status.should be(200)
    end
  end

  describe "GET /public/cart/delivery" do
    #after(:each) do
    #  FactoryGirl.reload
    #end

    context "not delivering" do
      it "should redirect if delivery not available" do
        menu_section_item = FactoryGirl.create(:menu_section_item)
        get public_menu_path(menu_section_item.menu_section.menu.id)
        post public_line_items_path(:item => menu_section_item.id)
        get public_cart_delivery_path
        response.status.should be(302)
      end
    end

    context "delivering" do
      it "should get delivery if delivering" do
        menu_section_item = FactoryGirl.create(:menu_section_item)
        get public_menu_path(menu_section_item.menu_section.menu.id)
        post public_line_items_path(:item => menu_section_item.id)
        FactoryGirl.create_list(:delivery_driver, 1, :locations => [menu_section_item.menu_section.menu.location])
        get public_cart_delivery_path
        response.status.should be(200)
      end
    end
  end
end
