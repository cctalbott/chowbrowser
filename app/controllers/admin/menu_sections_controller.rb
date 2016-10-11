class Admin::MenuSectionsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @menu_section = MenuSection.new
    @menu = Menu.find(params[:id])
    @menu_section.menu = @menu
  end
  
  def create
    @menu_section = MenuSection.new(params[:menu_section])
    @menu_section.menu_id = params[:id]
    
    if @menu_section.save
      redirect_to admin_menu_path(@menu_section.menu), :notice => 'Section added.'
    else
      redirect_to admin_menu_new_menu_section_path(params[:id]), :alert => 'Create menu failed.'
    end
  end
  
  def edit
    @menu_section = MenuSection.find(params[:id])
    @menu = @menu_section.menu
  end
  
  def update
    @menu_section = MenuSection.find(params[:id])
    
    if @menu_section.update_attributes(params[:menu_section])
      redirect_to admin_menu_path(@menu_section.menu), :notice => "Menu section updated."
    else
      redirect_to edit_admin_menu_section_path(@menu_section), :alert => "Edit menu section failed."
    end
  end
  
  def destroy
    @menu_section = MenuSection.find(params[:id])
    @menu = Menu.find(@menu_section.menu)
    @menu_section.destroy
    redirect_to admin_menu_path(@menu)
  end
end