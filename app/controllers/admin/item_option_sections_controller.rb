class Admin::ItemOptionSectionsController < AdminController
  load_and_authorize_resource

  def index_by_menu
    @item_option_sections = ItemOptionSection.by_menu(params[:menu_id])
    @menu = Menu.find(params[:menu_id])
  end

  def new
    @item_option_section = ItemOptionSection.new
    @menu_section_item = MenuSectionItem.find(params[:id])
    @item_option_section.menu_section_item = @menu_section_item
    @menu_sections_collection = @menu_section_item.menu_section.menu.menu_sections
  end

  def create
    @item_option_section = ItemOptionSection.new(params[:item_option_section])
    @item_option_section.menu_section_item_id = params[:id]

    if @item_option_section.save
      redirect_to admin_menu_section_item_path(@item_option_section.menu_section_item), :notice => 'Item option section added.'
    else
      redirect_to admin_menu_section_item_new_item_option_section_path(params[:id]), :alert => 'Create item option section failed.'
    end
  end

  def edit
    @item_option_section = ItemOptionSection.find(params[:id])
    @menu_section_item = @item_option_section.menu_section_items.first
    @menu_sections_collection = @menu_section_item.menu_section.menu.menu_sections
  end

  def update
    @item_option_section = ItemOptionSection.find(params[:id])

    if @item_option_section.update_attributes(params[:item_option_section])
      redirect_to admin_menu_section_item_path(@item_option_section.menu_section_item), :notice => "Item option section updated."
    else
      redirect_to admin_menu_section_item_edit_item_option_section_path(@item_option_section), :alert => "Edit item option section failed."
    end
  end

  def destroy
    @item_option_section = ItemOptionSection.find(params[:id])
    @menu_section_item = MenuSectionItem.find(@item_option_section.menu_section_item)
    @menu = Menu.find(@item_option_section.menu_section_items.first.menu_section.menu.id)
    @item_option_section.destroy
    #redirect_to admin_menu_section_item_path(@menu_section_item)
    redirect_to admin_item_option_sections_by_menu_path(@menu.id)
  end
end
