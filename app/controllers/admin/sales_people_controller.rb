class Admin::SalesPeopleController < AdminController
  load_and_authorize_resource
  before_filter :user_collection, :only => [:new, :create, :edit, :update]

  def index
    @sales_people = SalesPerson.all
  end

  def show
    @sales_person = SalesPerson.find(params[:id])
  end

  def new
    @sales_person = SalesPerson.new
    @submit_name = "Create Sales Person"
  end

  def create
    @sales_person = SalesPerson.new(params[:sales_person])

    if @sales_person.save
      redirect_to admin_sales_person_path(@sales_person), :notice => 'Sales Person added.'
    else
      redirect_to new_admin_sales_person_path, :alert => 'Add sales person failed.'
    end
  end

  def edit
    @sales_person = SalesPerson.find(params[:id])
    @submit_name = "Edit sales person"
  end

  def update
    @sales_person = SalesPerson.find(params[:id])

    if @sales_person.update_attributes(params[:sales_person])
      redirect_to admin_sales_person_path(@sales_person), :notice => "Sales Person updated."
    else
      redirect_to edit_admin_sales_person_path(@sales_person), :alert => "Sales Person update failed."
    end
  end

  def destroy
    @sales_person = SalesPerson.find(params[:id])
    @sales_person.destroy
    redirect_to admin_sales_people_path
  end

  protected

    def user_collection
      @user_collection = User.all.collect {|u| [u.email, u.id]}
    end
end
