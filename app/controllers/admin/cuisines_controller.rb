class Admin::CuisinesController < AdminController
  load_and_authorize_resource

  def index
    @cuisines = Cuisine.order("name ASC")
  end

  def show
    @cuisine = Cuisine.find(params[:id])
  end

  def new
    @cuisine = Cuisine.new
    @submit_name = "Create cuisine"
  end

  def create
    @cuisine = Cuisine.new(params[:cuisine])

    if @cuisine.save
      redirect_to admin_cuisines_path, :notice => 'New cuisine submitted.'
    else
      redirect_to new_admin_cuisine_path, :alert => 'New cuisine submission failed.'
    end
  end

  def edit
    @cuisine = Cuisine.find(params[:id])
    @submit_name = "Edit cuisine"
  end

  def update
    @cuisine = Cuisine.find(params[:id])

    if @cuisine.update_attributes(params[:cuisine])
      redirect_to admin_cuisine_path(@cuisine), :notice => "Cuisine updated."
    else
      redirect_to edit_admin_cuisine_path(@cuisine), :alert => "Cuisine update failed."
    end
  end

  def destroy
    @cuisine = Cuisine.find(params[:id])
    @cuisine.destroy
    redirect_to admin_cuisines_path
  end
end
