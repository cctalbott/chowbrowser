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
pdf.text "Report by #{@customer}", :size => 12, :style => :bold
pdf.text "Year: #{@year}, Month: #{@month}, Day: #{@day}", :size => 12, :style => :bold
# make space between page header and table
pdf.move_down(30)
pdf.text "Report Count: #{month_count(@orders)} | Report Avg: #{number_to_currency(month_average(@orders))} | Report Total: #{number_to_currency(total_by_selector(@orders))}", :size => 9, :align => :right, :width => 576
# Set table header
header = ["#", "Restaurant", "Day/Time", "Total"]
# populate table
items = @orders.map do |order|
  [
    order.id,
		truncate(order.restaurant_name),
		order.purchased_at.strftime("%Y %b %a %l:%M%p %Z"),
		number_to_currency(order.price)
  ]
end
# insert table header at beginning of table data
items.insert(0, header)
# style and output table
pdf.table items do |table|
  table.header = true
  table.cell_style = {:size => 8, :padding => [1, 2, 3, 2]}
  table.row_colors = ["FFFFFF", "DDDDDD"]
  table.columns(0).align = :center
  table.columns(1..2).align = :left
  table.columns(3).align = :right
  table.rows(0).style(:font_style => :bold)
  table.width = 539
end
pdf.repeat(:all, :dynamic => true) do
  draw_text "ChowBrowser", :size => 7, :at => [0, 720]
  draw_text "Page: #{page_number}", :size => 7, :at => [510, 720]
  draw_text "ChowBrowser", :size => 7, :at => [0, 0]
  draw_text "Page: #{page_number}", :size => 7, :at => [510, 0]
end
