class Public::LocationsController < PublicController
  load_and_authorize_resource
  skip_before_filter :authenticate_user!

  def show
    @location = Location.find(params[:id])
    @restaurant = @location.restaurant

    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
