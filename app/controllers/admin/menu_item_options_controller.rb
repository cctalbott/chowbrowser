class Admin::MenuItemOptionsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @menu_item_option = MenuItemOption.new
    @item_option_section = ItemOptionSection.find(params[:id])
    @menu_section_item = @item_option_section.menu_section_item
    @menu_item_option.menu_section_item = @menu_section_item
    @menu_item_option.item_option_section = @item_option_section
  end
  
  def create
    @menu_item_option = MenuItemOption.new(params[:menu_item_option])
    @menu_item_option.item_option_section_id = params[:id]
    @menu_item_option.menu_section_item_id = @menu_item_option.item_option_section.menu_section_item.id
    
    if @menu_item_option.save
      redirect_to admin_menu_section_item_path(@menu_item_option.menu_section_item), :notice => 'Item option added.'
    else
      redirect_to admin_item_option_section_new_menu_item_option_path(params[:id]), :alert => 'Create item option failed.'
    end
  end
  
  def edit
    @menu_item_option = MenuItemOption.find(params[:id])
    @item_option_section = @menu_item_option.item_option_section
    @menu_section_item = @item_option_section.menu_section_item
  end
  
  def update
    @menu_item_option = MenuItemOption.find(params[:id])
    
    if @menu_item_option.update_attributes(params[:menu_item_option])
      redirect_to admin_menu_section_item_path(@menu_item_option.item_option_section.menu_section_item), :notice => "Menu item option updated."
    else
      redirect_to admin_item_option_section_edit_menu_item_option_path(@menu_item_option), :alert => "Edit menu item option failed."
    end
  end
 
  def destroy
    @menu_item_option = MenuItemOption.find(params[:id])
    @item_option_section = @menu_item_option.item_option_section
    @menu_section_item = MenuSectionItem.find(@item_option_section.menu_section_item)
    @menu_item_option.destroy
    redirect_to admin_menu_section_item_path(@menu_section_item)
  end
end