require 'spec_helper'

describe Public::MenusController do
  login_customer

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "show" do
    menu = FactoryGirl.create(:menu)

    it "should get menu" do
      get "show", :id => menu.id
      response.should be_success
    end

    it "assigns menu to @menu" do
      get "show", :id => menu.id
      assigns(:menu).should eq(menu)
    end
  end

  Warden.test_reset!
end
