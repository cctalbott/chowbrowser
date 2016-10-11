class Public::LineItemOptionsController < PublicController
  load_and_authorize_resource
  #load_resource :except => [:destroy_option]
  #authorize_resource
  
  def destroy
    @line_item_option = LineItemOption.find(params[:id])
    @line_item_option.destroy
    
    respond_to do |format|
      format.html { redirect_to current_cart_path }
      format.js { redirect_to current_cart_path }
    end
  end
end