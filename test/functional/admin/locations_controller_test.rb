require 'test_helper'

class Admin::LocationsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    #@user.role = "admin"
    @attr = { :email => @user.email, :password => @user.encrypted_password }
    @location = locations(:one)
    #@the_session = Session.new
    assert post :create, :session => @attr

    #@ability = Object.new
    #@ability.extend(CanCan::Ability)
    #@controller.stubs(:current_ability).returns(@ability)
  end

  def teardown
    @location = nil
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #end

  test "should sign the user in" do
    #puts @user.roles
    #puts session
    assert_equal session[:email], @user.email
    #assert session[:current_user].signed_in?
  end

  #test "should get show" do
  #  get :show, :id => @location.id
  #  assert_response :success
  #  #assert_not_nil assigns(:location)
  #end

  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get :edit
  #  assert_response :success
  #end

  private
end
