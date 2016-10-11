class Admin::DeliveryDriversController < AdminController
  load_and_authorize_resource
  before_filter :collect_users, :only => [:new, :create, :edit, :update]

  def index
    @delivery_drivers = DeliveryDriver.all
  end

  def show
    @delivery_driver = DeliveryDriver.find(params[:id])
  end

  def new
    @delivery_driver = DeliveryDriver.new
    @submit_name = "Create delivery driver"
  end

  def create
    @delivery_driver = DeliveryDriver.new(params[:delivery_driver])

    if @delivery_driver.save
      redirect_to admin_delivery_drivers_path, :notice => 'New delivery driver submitted.'
    else
      redirect_to new_admin_delivery_driver_path, :alert => 'New delivery driver submission failed.'
    end
  end

  def edit
    @delivery_driver = DeliveryDriver.find(params[:id])
    @submit_name = "Edit delivery driver"
  end

  def update
    @delivery_driver = DeliveryDriver.find(params[:id])

    if @delivery_driver.update_attributes(params[:delivery_driver])
      redirect_to admin_delivery_driver_path(@delivery_driver), :notice => "Delivery Driver updated."
    else
      redirect_to edit_admin_delivery_driver_path(@delivery_driver), :alert => "Delivery Driver update failed."
    end
  end

  def destroy
    @delivery_driver = DeliveryDriver.find(params[:id])
    @delivery_driver.destroy
    redirect_to admin_delivery_drivers_path
  end

  protected

    def collect_users
      @users = User.select("email, id")
    end
end
