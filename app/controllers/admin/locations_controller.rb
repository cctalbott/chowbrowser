class Admin::LocationsController < AdminController
  load_and_authorize_resource
  #before_filter :user_collection, :only => [:new, :create, :edit, :update]
  before_filter :sales_person_collection, :only => [:new, :create, :edit, :update]
  before_filter :driver_collection, :only => [:new, :create, :edit, :update]

  def show
    @location = Location.find(params[:id])
    @restaurant = @location.restaurant
  end

  def new
    @location = Location.new
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    @location = Location.new(params[:location])
    @restaurant = Restaurant.find(params[:id])
    @location.restaurant = @restaurant

    if @location.save
      redirect_to admin_restaurant_path(@restaurant), :notice => 'Location added.'
    else
      redirect_to admin_restaurant_new_location_path(@location.restaurant), :alert => 'Add location failed.'
    end
  end

  def edit
    @location = Location.find(params[:id])
    @restaurant = @location.restaurant
    @submit_name = "Edit location"
  end

  def update
    params[:location][:user_ids] ||= []
    params[:location][:delivery_driver_ids] ||= []
    @location = Location.find(params[:id])

    if @location.update_attributes(params[:location])
      redirect_to admin_location_path(@location), :notice => "Location updated."
    else
      redirect_to edit_admin_location_path(@location), :alert => "Location update failed."
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @restaurant = @location.restaurant
    @location.destroy
    redirect_to admin_restaurant_path(@restaurant)
  end

  protected

    def user_collection
      #@user_collection = User.where("role = ?", "admin")
      @user_collection = User.where(:role => ["admin", "restaurant_owner", "restaurant_editor"])
    end

    def sales_person_collection
      @sales_person_collection = SalesPerson.all.collect {|sp| [sp.user.email, sp.id]}
    end

    def driver_collection
      @driver_collection = DeliveryDriver.joins(:user)
    end
end
