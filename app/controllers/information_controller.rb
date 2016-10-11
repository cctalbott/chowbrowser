class InformationController < ApplicationController
  skip_before_filter :authenticate_user!

  def about
  end

  def faq
  end

  def delivery
    @restaurants = Restaurant.joins(:locations => :delivery).where("locations.active = ? AND restaurants.id != ?", true, 11)
  end

  def restaurant
  end

  def privacy
  end

  def terms
  end
end
