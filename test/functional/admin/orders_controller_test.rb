require 'test_helper'

class Admin::OrdersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    sign_in @user
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #end

  test "should sign the user in" do
    #puts @user.role
    puts session
    #assert_equal session[:email], @user.email
    #assert current_user.signed_in?
    assert_not_nil session[:email]
  end

  test "should get incomplete" do
    get :incomplete_orders
    assert_response :success
    #assert_not_nil assigns(:location)
  end

  test "should get complete" do
    get :complete_orders
    assert_response :success
  end

  #test "should get edit" do
  #  get :edit
  #  assert_response :success
  #end

  private
end
