class Public::MenuSectionItemsController < PublicController
  load_and_authorize_resource
  
  def show
    @item = MenuSectionItem.find(params[:id])
    
    respond_to do |format|
      format.html {render :layout => "ajax"}
      #format.js
    end
  end
end