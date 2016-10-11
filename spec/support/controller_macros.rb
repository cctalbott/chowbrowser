include Warden::Test::Helpers
Warden.test_mode!

module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      user = FactoryGirl.create(:admin)
      sign_in user # Using factory girl as an example
    end
  end

  def login_customer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:customer]
      user = FactoryGirl.create(:customer)
      sign_in user
    end
  end
end
