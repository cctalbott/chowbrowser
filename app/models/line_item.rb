class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :menu_section_item
  has_many :line_item_options, :dependent => :destroy
  #has_one :line_item_option, :dependent => :destroy
  has_many :menu_item_options, :through => :line_item_options
  #has_one :menu_item_option, :through => :line_item_option
  accepts_nested_attributes_for :line_item_options
  #accepts_nested_attributes_for :line_item_option
  accepts_nested_attributes_for :menu_item_options
  #validates_associated :cart, :menu_section_item, :line_item_options, :menu_item_options
  #validates_associated :line_item_options
  validate :menu_within_time

  def full_price
    option_total = 0.0
    line_item_options.each do |lio|
      option_total += lio.qty.to_f * lio.menu_item_option.price.to_f
    end
    total = ((unit_price * quantity) + (option_total.to_f * quantity)).to_f
    return total
  end

  private

    def menu_within_time
      time_in_seconds = Time.now.min + (Time.now.hour * 60)
      menu_section_item.menu_section.menu.menu_hours.each do |menu_hour|
        if(menu_hour.menu_start_hour && menu_hour.menu_start_min && menu_hour.menu_end_hour && menu_hour.menu_end_min)
          menu_start = (menu_hour.menu_start_hour * 60) + menu_hour.menu_start_min
          menu_end = (menu_hour.menu_end_hour * 60) + menu_hour.menu_end_min
          unless((menu_start <= time_in_seconds) && (menu_end >= time_in_seconds))
            errors[:base] << "Menu is not accepting orders at this time."
          end
        end
      end
    end
end
