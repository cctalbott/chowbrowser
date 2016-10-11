class Admin::SalesOfficesController < AdminController
  load_and_authorize_resource
  before_filter :location_collection, :only => [:new, :create, :edit, :update]

  def index
    @sales_offices = SalesOffice.all
  end

  def show
    @sales_office = SalesOffice.find(params[:id])
  end

  def new
    @sales_office = SalesOffice.new
    @submit_name = "Create sales office"
  end

  def create
    @sales_office = SalesOffice.new(params[:sales_office])

    if @sales_office.save
      redirect_to admin_sales_offices_path, :notice => 'New sales office submitted.'
    else
      redirect_to new_admin_sales_office_path, :alert => 'New sales office submission failed.'
    end
  end

  def edit
    @sales_office = SalesOffice.find(params[:id])
    @submit_name = "Edit sales office"
  end

  def update
    params[:sales_office][:location_ids] ||= []
    @sales_office = SalesOffice.find(params[:id])

    if @sales_office.update_attributes(params[:sales_office])
      redirect_to admin_sales_office_path(@sales_office), :notice => "Sales office updated."
    else
      redirect_to edit_admin_sales_office_path(@sales_office), :alert => "Sales office update failed."
    end
  end

  def destroy
    @sales_office = SalesOffice.find(params[:id])
    @sales_office.destroy
    redirect_to admin_sales_offices_path
  end

  protected

    def location_collection
      @location_collection = Location.all
    end
end
