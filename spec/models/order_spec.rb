require 'spec_helper'

describe Order do
  it "has a valid factory" do
    FactoryGirl.create(:order).should be_valid
  end

  it "is invalid with improperly formatted email" do
    FactoryGirl.build(:order, :email => "a**@**a@.dumb").should_not be_valid
  end

  it "is invalid with improperly formatted phone" do
    FactoryGirl.build(:order, :phone => "555/555(5555)").should_not be_valid
  end
end
