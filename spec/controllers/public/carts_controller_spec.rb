require 'spec_helper'

describe Public::CartsController do
  login_customer

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "show" do
    cart = FactoryGirl.create(:cart)

    it "should get cart" do
      get 'show', :id => cart.id
      response.should be_success
    end
  end

  describe "delivery" do
    context "not delivering" do
      before do
        cart = FactoryGirl.create(:cart)
        session[:cart_id] = cart.id
      end

      it "should redirect if delivery not available" do
        get "delivery"
        response.should redirect_to(new_public_order_path)
      end
    end

    context "is delivering" do
      before do
        cart = FactoryGirl.create(:cart)
        session[:cart_id] = cart.id
        FactoryGirl.create_list(:delivery_driver, 1, :locations => [cart.location])
      end

      it "should get delivery if delivery available" do
        get "delivery"
        response.should be_success
      end

      it "should update delivery if delivery available" do
        post "update_delivery", :cart => {
            :delivers => true, :delivery_address => {
              :address => "123 First St",
              :city => "Lubbock",
              :zip => "79424"
            }
          }
        controller.params[:cart][:delivers].should_not be_nil
        controller.params[:cart][:delivers].should eql TRUE
        controller.params[:cart][:delivery_address].should_not be_nil
        controller.params[:cart][:delivery_address][:address].should_not be_nil
        controller.params[:cart][:delivery_address][:address].should eql "123 First St"
        response.should redirect_to(public_cart_tip_path)
      end
    end
  end

  describe "tip" do
    context "not delivering" do
      before do
        cart = FactoryGirl.create(:cart)
        session[:cart_id] = cart.id
      end

      it "should redirect if not delivering or delivery not available" do
        get "tip"
        response.should redirect_to(new_public_order_path)
      end
    end

    context "is delivering" do
      before do
        cart = FactoryGirl.create(:cart)
        session[:cart_id] = cart.id
        FactoryGirl.create_list(:delivery_driver, 1, :locations => [cart.location])
      end

      it "should get tip if delivery available and delivering" do
        get "delivery"
        response.should be_success
      end
    end
  end

  Warden.test_reset!
end
