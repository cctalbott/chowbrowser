require 'spec_helper'

describe Public::RestaurantsController do
  login_customer

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "index" do
    it "should get index" do
      get 'index'
      response.should be_success
    end

    it "assigns restaurants to @restaurants" do
      restaurants = Restaurant.active
      get :index
      assigns(:restaurants).should eq(restaurants)
    end
  end

  Warden.test_reset!
end
