class Public::MenuItemOptionsController < PublicController
  load_and_authorize_resource

  def select
    @menu_item_option = MenuItemOption.find(params[:id])
    @menu_section_item = @menu_item_option.menu_section_item
    @line_item = LineItem.find(params[:line_item_id])
    flash[:notice] = "Added #{@menu_section_item.name} to cart."

    @line_item_option = LineItemOption.new(:menu_item_option => @menu_item_option, :line_item => @line_item, :price => @menu_item_option.price, :name => @menu_item_option.name)

    respond_to do |format|
      if @line_item_option.save
        format.html { redirect_to current_cart_path, :notice => 'Item option added.' }
        format.js { redirect_to current_cart_path, :notice => 'Item option added.' }
      else
        format.html { redirect_to current_cart_path, :alert => 'Failed to add item option to order.' }
        format.js { redirect_to current_cart_path, :alert => 'Failed to add item option to order.' }
      end
    end
  end
end
