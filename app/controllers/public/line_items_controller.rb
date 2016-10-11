class Public::LineItemsController < PublicController
  #load_and_authorize_resource
  load_resource :except => [:destroy_option]
  authorize_resource

  before_filter :destroy_lio, :only => [:edit]

  def new
    @item = MenuSectionItem.find(params[:item])
    @line_item = LineItem.new

    if @item.item_option_sections
      @item_option_sections = @item.item_option_sections
      @line_item.line_item_options.build(:line_item_id => @line_item)
    end

    respond_to do |format|
      format.html { render :layout => "ajax" }
    end
  end

  def create
    @menu_section_item = MenuSectionItem.find(params[:item])
    #@line_item = LineItem.create!(:cart => current_cart, :menu_section_item => @menu_section_item, :quantity => 1, :unit_price => @menu_section_item.price)
    @line_item = LineItem.new(params[:line_item])
    @line_item.menu_section_item = @menu_section_item
    @line_item.cart = current_cart
    @line_item.quantity = params[:quantity] ? params[:quantity] : 1
    @line_item.unit_price = @menu_section_item.price
    @line_item.name = @menu_section_item.name

    if @line_item.save
      redirect_to public_menu_path(@menu_section_item.menu_section.menu.id), :notice => "Added #{@menu_section_item.name} to cart."
    else
      alert = "Failed to add #{@menu_section_item.name} to cart."
      if @line_item.errors
        @line_item.errors.full_messages.each { |msg| alert += " #{msg}" }
      end
      redirect_to public_menu_path(@menu_section_item.menu_section.menu.id), :alert => alert
    end
  end

  def edit
    @line_item = LineItem.find(params[:id])
    @item = @line_item.menu_section_item

    @item_option_sections = @item.item_option_sections

    #@line_item.line_item_options.destroy_option
    @line_item.line_item_options.build(:line_item_id => @line_item)
  end

  def update
    @line_item = LineItem.find(params[:id])
    @item = @line_item.menu_section_item

    if params[:quantity]
      @line_item.quantity = params[:quantity]
    end

    if @line_item.update_attributes(params[:line_item])
      respond_to do |format|
        format.html { redirect_to public_menu_path(@item.menu_section.menu.id), :notice => "Item updated." }
        format.js { redirect_to current_cart_path, :notice => "Item updated." }
      end
    else
      respond_to do |format|
        format.html { redirect_to public_menu_path(@item.menu_section.menu.id), :alert => "Item update failed." }
        format.js { redirect_to current_cart_path, :alert => "Item update failed." }
      end
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.quantity = @line_item.quantity.to_int - 1
    @line_item.update_attributes(params[:line_item])
    if @line_item.quantity == 0
      @line_item.destroy
    end

    respond_to do |format|
      format.html { redirect_to current_cart_path }
      format.js { redirect_to current_cart_path }
    end
  end

  def destroy_option
    @line_item_option = LineItemOption.find(params[:id])
    @line_item_option.destroy

    respond_to do |format|
      format.html { redirect_to current_cart_path }
      format.js { redirect_to current_cart_path }
    end
  end

  def destroy_lio
    @line_item = LineItem.find(params[:id])

    @line_item.line_item_options.each do |lio|
      lio.destroy
    end
  end
end
