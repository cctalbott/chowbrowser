class Admin::PrintersController < AdminController
  load_and_authorize_resource
  before_filter :location_collection, :only => [:new, :create, :edit, :update]

  def index
    @printers = Printer.all
  end

  def show
    @printer = Printer.find(params[:id])
  end

  def new
    @printer = Printer.new
    @submit_name = "Create printer"
  end

  def create
    @printer = Printer.new(params[:printer])

    if @printer.save
      redirect_to admin_printer_path(@printer), :notice => 'Printer added.'
    else
      redirect_to new_admin_printer_path, :alert => 'Add printer failed.'
    end
  end

  def edit
    @printer = Printer.find(params[:id])
    @submit_name = "Edit printer"
  end

  def update
    @printer = Printer.find(params[:id])

    if @printer.update_attributes(params[:printer])
      redirect_to admin_printer_path(@printer), :notice => "Printer updated."
    else
      redirect_to edit_admin_printer_path(@printer), :alert => "Printer update failed."
    end
  end

  def destroy
    @printer = Printer.find(params[:id])
    @printer.destroy
    redirect_to admin_printers_path
  end

  protected

    def location_collection
      @location_collection = Location.all
    end
end
