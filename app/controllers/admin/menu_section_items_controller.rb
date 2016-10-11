class Admin::MenuSectionItemsController < AdminController
  load_and_authorize_resource
  
  def show
    @item = MenuSectionItem.find(params[:id])
  end
  
  def new
    @menu_section_item = MenuSectionItem.new
    @menu_section = MenuSection.find(params[:id])
    @menu_section_item.menu_section = @menu_section
  end
  
  def create
    @menu_section_item = MenuSectionItem.new(params[:menu_section_item])
    @menu_section_item.menu_section_id = params[:id]
    
    if @menu_section_item.save
      redirect_to admin_menu_path(@menu_section_item.menu_section.menu), :notice => 'Item added.'
    else
      redirect_to admin_menu_section_new_menu_section_item_path(params[:id]), :alert => 'Create item failed.'
    end
  end
  
  def edit
    @menu_section_item = MenuSectionItem.find(params[:id])
    @menu_section = @menu_section_item.menu_section
  end
  
  def update
    @menu_section_item = MenuSectionItem.find(params[:id])
    
    if @menu_section_item.update_attributes(params[:menu_section_item])
      redirect_to admin_menu_path(@menu_section_item.menu_section.menu), :notice => "Menu section item updated."
    else
      redirect_to admin_menu_section_edit_menu_section_item_path(@menu_section_item), :alert => "Edit menu section item failed."
    end
  end
  
  def destroy
    @menu_section_item = MenuSectionItem.find(params[:id])
    @menu = Menu.find(@menu_section_item.menu_section.menu)
    @menu_section_item.destroy
    redirect_to admin_menu_path(@menu)
  end
end