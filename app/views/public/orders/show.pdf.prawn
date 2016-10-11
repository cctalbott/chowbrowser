pdf.font("Times-Roman")
pdf.move_down(10)
pdf.image "#{Rails.root}/app/assets/images/chowbrowser-icon.png", :scale => 0.5
pdf.move_down(10)
pdf.stroke do
  horizontal_rule
  stroke_color "002F5C"
end
pdf.move_down(10)
# Set page header and information
pdf.text "Order #{@order.id}", :size => 12, :style => :bold
pdf.text "Customer: #{@order.email}", :size => 10, :style => :bold
pdf.text "Placed: #{@order.created_at.strftime('%a, %d %b %Y %I:%S%p %Z')}", :size => 10, :style => :bold
pdf.text "Restaurant: #{@order.restaurant_name}", :size => 10, :style => :bold
pdf.text "Location: #{@order.location_address}", :size => 10, :style => :bold
# Set table header
header = ["Item", "Price"]
# populate table
items = @order.cart.line_items.map do |line_item|
  [
    line_item.menu_section_item.name,
		number_to_currency(line_item_total(line_item))
  ]
end
# insert table header at beginning of table data
items.insert(0, header)
# make space between page header and table
pdf.move_down(20)
# style and output table
pdf.table items do |table|
  table.header = true
  table.cell_style = {:size => 8, :padding => [1, 2, 3, 2]}
  table.row_colors = ["FFFFFF", "DDDDDD"]
  table.columns(0).align = :left
  table.columns(1).align = :right
  table.rows(0).style(:font_style => :bold)
  table.width = 539
end
pdf.move_down(20)
pdf.text "Sub Total: #{number_to_currency(sub_total(@order))}", :size => 10, :style => :bold
pdf.text "Tax: #{number_to_currency(tax(@order))}", :size => 10, :style => :bold
if @order.cart.delivers && @order.cart.tip
  pdf.text "Tip: #{number_to_currency(tip(@order))}", :size => 10, :style => :bold
end
pdf.text "Grand Total: #{number_to_currency(total(@order))}", :size => 10, :style => :bold
pdf.repeat(:all, :dynamic => true) do
  draw_text "ChowBrowser", :size => 7, :at => [0, 720]
  draw_text "Page: #{page_number}", :size => 7, :at => [510, 720]
  draw_text "ChowBrowser", :size => 7, :at => [0, 0]
  draw_text "Page: #{page_number}", :size => 7, :at => [510, 0]
end
