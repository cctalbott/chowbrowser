class Admin::RestaurantsController < AdminController
  #before_filter :authenticate_user!
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  before_filter :cuisine_collection, :only => [:new, :create, :edit, :update]

  def index
    @restaurants = Restaurant.order(sort_column + " " + sort_direction)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
    location = @restaurant.locations.build
    @submit_name = "Create restaurant"
  end

  def create
    @restaurant = Restaurant.new(params[:restaurant])

    if @restaurant.save
      redirect_to admin_restaurants_path, :notice => 'Application submitted.'
    else
      redirect_to new_admin_restaurant_path, :alert => 'Application submission failed.'
    end
  end

  def import_csv
  end

  def create_csv
    require 'csv'

    csv = CSV.parse(params[:dump][:file].read, :headers => true)

    csv.each do |row|
      restaurant = Restaurant.new(:name => row[0], :description => row[1])
      restaurant.save
      location = Location.new(:address => row[2], :city => row[3], :region => row[4], :postal_code => row[5], :restaurant_id => restaurant.id.to_i)
      location.save
    end

    redirect_to admin_restaurants_path
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @submit_name = "Edit restaurant"
  end

  def update
    @restaurant = Restaurant.find(params[:id])

    if @restaurant.update_attributes(params[:restaurant])
      redirect_to admin_restaurant_path(@restaurant), :notice => "Restaurant updated."
    else
      redirect_to edit_admin_restaurant_path(@restaurant), :alert => "Restaurant update failed."
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to admin_restaurants_path
  end

  private

    def sort_column
      Restaurant.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

  protected

    def cuisine_collection
      @cuisine_collection = Cuisine.order("name ASC")
    end
end
