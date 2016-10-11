require 'spec_helper'

describe Public::OrdersController do
  login_customer

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  it "should get index" do
    get 'index'
    response.should be_success
  end

  describe "new" do
    it "should get new" do
      get "new"
      response.should be_success
    end

    it "should complete order" do
      cart = FactoryGirl.create(:cart, :purchased)
      order = FactoryGirl.create(:order, :confirmed)
      order.cart = cart
      order.save
      get :success, :id => order.id
      assigns(:order).should eq(order)
    end

    it "should complete delivery order" do
      cart = FactoryGirl.create(:cart, :purchased, :delivers)
      order = FactoryGirl.create(:order, :delivering)
      order.cart = cart
      order.save
      get :success, :id => order.id
      assigns(:order).should eq(order)
    end
  end
=begin
  it "should get index" do
    get 'index'
    response.should be_success
  end

  describe "incomplete_orders" do
    it "should get incomplete_orders" do
      get 'incomplete_orders'
      response.should be_success
    end

    it "assigns incomplete orders to @orders" do
      cart = FactoryGirl.create(:cart)
      order = FactoryGirl.create(:order)
      order.cart = cart
      order.save
      get :incomplete_orders
      assigns(:orders).should eq([order])
    end
  end

  describe "complete_orders" do
    it "should get complete_orders" do
      get 'complete_orders'
      response.should be_success
    end

    it "assigns complete orders to @orders" do
      cart = FactoryGirl.create(:cart, :purchased)
      order = FactoryGirl.create(:order, :confirmed)
      order.cart = cart
      order.save
      get :complete_orders
      assigns(:orders).should eq([order])
    end
  end

  describe "update_status" do
    it "assigns order to @order" do
      cart = FactoryGirl.create(:cart)
      order = FactoryGirl.create(:order)
      order.cart = cart
      order.save
      get :update_status, :id => order.id
      assigns(:order).should eq(order)
    end

    it "should get update_status" do
      cart = FactoryGirl.create(:cart)
      order = FactoryGirl.create(:order)
      order.cart = cart
      order.save
      get 'update_status', :id => order.id
      response.should be_success
    end
  end
=end
  Warden.test_reset!
end
