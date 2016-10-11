class Cart < ActiveRecord::Base
  #include Rails.application.routes.url_helpers
  has_many :line_items, :dependent => :destroy
  has_one :order
  belongs_to :delivery_address
  belongs_to :delivery_driver
  accepts_nested_attributes_for :delivery_address, :allow_destroy => true
  validates :driver_email, :length => { :in => 1..150 }, :allow_blank => true,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  if Rails.env.production? || Rails.env.development? || Rails.env.staging?
    scope :purchased, select("purchased_at").where("purchased_at IS NOT NULL")
    scope :by_year, lambda { |year|
      purchased.where("extract(year from purchased_at) = ?", year)
    }
  else
    scope :purchased, select("purchased_at").where("purchased_at IS NOT NULL")
    scope :by_year, lambda { |year|
      purchased.where("strftime('%Y', purchased_at) = ?", year)
    }
  end
  # db max => 5
  validates :delivery_distance, :length => {:maximum => 2},
    :numericality => { :only_integer => true, :less_than_or_equal_to => 11 }, :allow_blank => true
  # db max => 4
  validates :delivery_duration, :length => {:maximum => 3},
    :numericality => { :only_integer => true, :less_than_or_equal_to => 120 }, :allow_blank => true
  #validates_associated :line_items, :order

  def total_price
    # convert to array so it doesn't try to do sum on database directly
    total = 0.0
    if delivers
      total += line_items.to_a.sum(&:full_price) + location.delivery.fee.to_f
    else
      total += line_items.to_a.sum(&:full_price)
    end
    return total
  end

  def tax
    total_price.to_f * 0.0825
  end

  def plus_tip
    if self.tip && self.tip > 0
      total = total_price.to_f + self.tip.to_f
    end
    return total
  end

  #def to_path
  #  public_orders_path(:year => self.year, :month => self.month)
  #end

  def year
    purchased_at.year
  end

  def month
    purchased_at.month
  end

  def self.sweep
    @carts = Cart.where("created_at < '#{12.hours.ago.to_s(:db)}' AND
      purchased_at IS NULL")
    @carts.each do |cart|
      if cart.order
        cart.order.destroy
      end
      cart.destroy
    end
  end

  def location
    line_items.first.menu_section_item.location
  end
end
