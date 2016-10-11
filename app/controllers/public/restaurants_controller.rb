require 'builder'

class Public::RestaurantsController < PublicController
  #before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    if params[:cuisine]
      @cuisine = Cuisine.find(params[:cuisine])
      if can? :manage, Restaurant
        @restaurants = Restaurant.by_cuisine(@cuisine.id).active_admin
      else
        @restaurants = Restaurant.by_cuisine(@cuisine.id).active
      end
      @restaurants = @restaurants.each { |r| r.locations.reject! { |l|
        !l.drivers_active? && !l.delivers } }
=begin
      unless @restaurants.exists?
        if can? :manage, Restaurant
          @restaurants = Restaurant.active_admin
        else
          @restaurants = Restaurant.active
        end
      end
=end
    else
      if can? :manage, Restaurant
        @restaurants = Restaurant.active_admin
      else
        @restaurants = Restaurant.active
      end
    end
    @cuisines = Cuisine.all

    respond_to do |format|
      format.html
      #format.xml { render :xml => @restaurants }
      format.xml
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
