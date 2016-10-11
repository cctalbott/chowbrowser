require 'spec_helper'

describe Cart do
  it "has a valid factory" do
    FactoryGirl.create(:cart).should be_valid
  end

  it "is invalid with improperly formatted driver_email" do
    FactoryGirl.build(:cart, :driver_email => "a**@**a@.dumb").should_not be_valid
  end

  it "is invalid if driver_email > 150 characters" do
    FactoryGirl.build(:cart, :driver_email => "#{(0...151).map{65.+(rand(25)).chr}.join}@test.com").should_not be_valid
  end

  it "is invalid if delivery_distance is not integer" do
    FactoryGirl.build(:cart, :delivery_distance => 10.1).should_not be_valid
  end

  it "is invalid if delivery_distance > 11" do
    FactoryGirl.build(:cart, :delivery_distance => 12).should_not be_valid
  end

  it "is invalid if delivery_duration is not integer" do
    FactoryGirl.build(:cart, :delivery_duration => 10.1).should_not be_valid
  end

  it "is invalid if delivery_duration > 120" do
    FactoryGirl.build(:cart, :delivery_duration => 121).should_not be_valid
  end

  it "calculates total price" do
    cart = FactoryGirl.create(:cart)
    cart.total_price.should == 3.0
  end

  it "calculates tax" do
    cart = FactoryGirl.create(:cart)
    cart.tax.should == (3.0 * 0.0825)
  end
end
