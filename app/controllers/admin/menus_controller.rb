class Admin::MenusController < AdminController
  
  def show
    @menu = Menu.find(params[:id])
    @menu_sections = @menu.menu_sections.order("position ASC, created_at ASC")
  end
  
  def new
    @menu = Menu.new
    @location = Location.find(params[:id])
    @menu.location = @location
  end
  
  def create
    @menu = Menu.new(params[:menu])
    @menu.location_id = params[:id]
    
    if @menu.save
      redirect_to admin_location_path(@menu.location), :notice => 'Menu added.'
    else
      redirect_to admin_location_new_menu_path(@menu.location), :alert => 'Create menu failed.'
    end
  end
  
  def import_csv
  end
  
  def create_csv
    require 'csv'
    
    @location = Location.find(params[:id])
    csv = CSV.parse(params[:dump][:file].read, :headers => true)
    
    csv.each do |row|
      if row[7] != "yes"
        # Menu Item
        if Menu.where(:location_id => @location, :name => row[0]).exists?
          menu = Menu.where(:location_id => @location, :name => row[0]).first
        else
          menu = Menu.new(:name => row[0])
          menu.location_id = @location.id.to_i
          menu.save
        end
      
        if MenuSection.where(:menu_id => menu, :name => row[1]).exists?
          menu_section = MenuSection.where(:menu_id => menu, :name => row[1]).first
        else
          menu_section = MenuSection.new(:name => row[1])
          menu_section.menu_id = menu.id.to_i
          menu_section.save
        end
        
        unless MenuSectionItem.where(:menu_section_id => menu_section, :name => row[2]).exists?
          item = MenuSectionItem.new(:name => row[2], :price => row[4], :description => row[3])
          item.menu_section_id = menu_section.id.to_i
          item.save
        end
      else
        # Item Option
        menu = Menu.where(:location_id => @location, :name => row[0]).first
        menu_section = MenuSection.where(:menu_id => menu, :name => row[1]).first
        item = MenuSectionItem.where(:menu_section_id => menu_section, :name => row[2]).first
        
        if ItemOptionSection.where(:menu_section_item_id => item, :name => row[5]).exists?
          option_section = ItemOptionSection.where(:menu_section_item_id => item, :name => row[5]).first
        else
          option_section = ItemOptionSection.new(:name => row[5])
          option_section.menu_section_item_id = item.id.to_i
          option_section.save
        end
        
        unless MenuItemOption.where(:item_option_section_id => option_section, :name => row[6]).exists?
          item_option = MenuItemOption.new(:name => row[6], :price => row[4])
          item_option.item_option_section_id = option_section.id.to_i
          item_option.save
        end
      end
    end
    
    redirect_to admin_location_path(@location)
  end

  def edit
    @menu = Menu.find(params[:id])
    @location = @menu.location
  end
  
  def update
    @menu = Menu.find(params[:id])
    
    if @menu.update_attributes(params[:menu])
      redirect_to admin_menu_path(@menu), :notice => "Menu updated."
    else
      redirect_to edit_admin_menu_path(@menu), :alert => "Edit menu failed."
    end
  end
  
  def destroy
    @menu = Menu.find(params[:id])
    @location = Location.find(@menu.location)
    @menu.destroy
    redirect_to admin_location_path(@location)
  end
end
