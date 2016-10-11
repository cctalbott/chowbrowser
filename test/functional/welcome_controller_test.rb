require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  #setup :initialize_welcome
  
  test "should get index" do
    get :index
    assert_response :success
  end
=begin  
  private
  
  def initialize_welcome
    @controller = WelcomeController.new
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @user.stubs(:current_ability).returns(@ability)
  end
=end
end
