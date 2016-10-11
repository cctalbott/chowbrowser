class Order < ActiveRecord::Base
  belongs_to :cart
  belongs_to :user
  has_many :transactions, :class_name => "OrderTransaction"
  has_one :billing_address
  has_one :delivery_address, :through => :cart
  has_and_belongs_to_many :call_statuses
  attr_accessor :card_number, :card_verification, :price,
    :purchased_at
  validate :validate_card, :on => :create
  validates :ip_address, :card_type, :card_expires_on, :email,
    :presence => true
  validates :email,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates :phone, :presence => true, :length => { :in => 1..50 },
    :format => { :with => /^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$/ }
  #validates_associated :cart, :transactions
  validates_associated :billing_address, :delivery_address
  accepts_nested_attributes_for :billing_address, :allow_destroy => true
  accepts_nested_attributes_for :delivery_address, :allow_destroy => true
  accepts_nested_attributes_for :cart, :allow_destroy => true
  scope :purchased, where("carts.purchased_at IS NOT NULL")
  scope :delivers, where("carts.delivers = ?", true)
  #scope :delivers, where(:cart => {:delivers => true})

  def self.by_year(year)
    query = purchased
    if Rails.env.production? || Rails.env.development? || Rails.env.staging?
      query = query.where("extract(year from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') = ?", year)
    else
      query = query.where("strftime('%Y', carts.purchased_at) = ?", year)
    end
    return query
  end

  def self.by_month_and_year(month, year)
    query = by_year(year)
    if Rails.env.production? || Rails.env.development? || Rails.env.staging?
      query = query.where("extract(month from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') = ?", month)
    else
      query = query.where("strftime('%m', carts.purchased_at) = ?", month)
    end
    return query
  end

  def self.by_day(month, year, day)
    query = by_month_and_year(month, year)
    if Rails.env.production? || Rails.env.development? || Rails.env.staging?
      query = query.where("extract(day from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') = ?", day)
    else
      query = query.where("strftime('%d', carts.purchased_at) = ?", day)
    end
    return query
  end

  def self.by_customer(email)
    where("orders.email = ?", email)
  end

  def self.purchased_by_customer(email, month, year)
    query = select("DISTINCT orders.*, carts.purchased_at").joins(:cart)
    unless year == "all"
      if month == "all"
        query = query.by_year(year)
      else
        query = query.by_month_and_year(month, year)
      end
    end
    query = query.by_customer(email)
  end

  def self.location_join
    joins(:cart => {:line_items => {:menu_section_item => {:menu_section =>
      {:menu => :location}}}})
  end

  def self.location_numbers_join
    joins(:cart => {:line_items => {:menu_section_item => {:menu_section =>
      {:menu => {:location => :location_numbers}}}}})
  end

  def self.restaurant_join(restaurant)
    joins(:cart => {:line_items => {:menu_section_item => {:menu_section =>
      {:menu => {:location => :restaurant}}}}}).where(:cart => {:line_items =>
      {:menu_section_item => {:menu_section => {:menu => {:location =>
      {:restaurants => {:name => restaurant}}}}}}})
  end

  def self.restaurants_join(restaurants)
    joins(:cart => {:line_items => {:menu_section_item => {:menu_section =>
      {:menu => {:location => :restaurant}}}}}).where(:cart => {:line_items =>
      {:menu_section_item => {:menu_section => {:menu => {:location =>
      {:restaurants => {:id => restaurants}}}}}}})
  end

  def self.by_restaurants(restaurants)
    where(:cart => {:line_items => {:menu_section_item => {:menu_section =>
      {:menu => {:location => {:restaurants => {:id => restaurants}}}}}}})
  end

  def self.purchased_at_restaurant(month, year, restaurant)
    query = select("DISTINCT orders.*, restaurants.name, orders.id,
      carts.purchased_at").restaurant_join(restaurant)
    unless year == "all"
      if month == "all"
        query = query.by_year(year)
      else
        query = query.by_month_and_year(month, year)
      end
    end
    query = query.purchased
    return query
  end

  def self.year_collection(restaurant = nil, customer = nil)
    if restaurant != nil
      query = select("DISTINCT extract(year from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') AS
        purchased_at_year, restaurants.name").restaurant_join(restaurant)
    elsif customer != nil
      query = select("DISTINCT extract(year from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') AS
        purchased_at_year, orders.email").joins(:cart).by_customer(customer)
    else
      query = select("DISTINCT extract(year from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') AS
        purchased_at_year").joins(:cart)
    end
    query = query.purchased
    return query
  end

  def self.month_collection(year, restaurant = nil, customer = nil)
    if restaurant != nil
      query = select("DISTINCT extract(month from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_month, restaurants.name").restaurant_join(restaurant)
    elsif customer != nil
      query = select("DISTINCT extract(month from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_month, orders.email").joins(:cart).by_customer(customer)
    else
      query = select("DISTINCT extract(month from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_month").joins(:cart)
    end
    query = query.by_year(year)
    return query
  end

  def self.day_collection(month, year, restaurant = nil, customer = nil)
    if restaurant != nil
      query = select("DISTINCT extract(day from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_day, restaurants.name").restaurant_join(restaurant)
    elsif customer != nil
      query = select("DISTINCT extract(day from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_day, orders.email").joins(:cart).by_customer(customer)
    else
      query = select("DISTINCT extract(day from carts.purchased_at::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'America/Chicago') as
        purchased_at_day").joins(:cart)
    end
    query = query.by_month_and_year(month, year)
    return query
  end

  def self.restaurant_collection(month, year)
    query = select("restaurants.name, restaurants.id").purchased.joins(
      :cart => {:line_items => {:menu_section_item => {:menu_section => {
      :menu => {:location => :restaurant}}}}})
    unless year == "all"
      if month == "all"
        query = query.by_year(year)
      else
        query = query.by_month_and_year(month, year)
      end
    end
    query = query.order("restaurants.name DESC")
    return query
  end

  def self.customer_collection(month, year)
    query = select("DISTINCT orders.email, orders.id").purchased.joins(:cart)
    unless year == "all"
      if month == "all"
        query = query.by_year(year)
      else
        query = query.by_month_and_year(month, year)
      end
    end
    query = query.order("orders.email ASC")
    return query
  end

  def self.purchase(id)
    find(id).purchase
  end

  def self.send_reports
    @os = joins(:cart).by_day(Time.now.month, Time.now.year, Time.now.day).purchased
    #@os = joins(:cart).by_day(8, 2012, 23).purchased
    if @os && @os.length > 0
      @os_by_restaurant_emails = @os.group_by {|o| o.restaurant.report_email}
      @os_by_restaurant_emails.each do |email, orders|
        ReportMailer.orders_report(orders, email).deliver
        #ReportMailer.orders_report(orders, "redacted@domain.com").deliver
      end
    end
  end

  def month_to_name
    month = Date.new(Time.now.year, purchased_at_month.to_i)
    month.strftime("%B")
  end

  def authorize
    if self.cart.tip && self.cart.tip > 0
      @amount = price_in_cents + tax_in_cents + tip_in_cents
    else
      @amount = price_in_cents + tax_in_cents
    end
    response = GATEWAY.authorize((@amount), credit_card, purchase_options)
    transactions.create!(:action => "authorize", :amount => (@amount), :response => response)
    response.success?
  end

  def purchase
    #@cart = Cart.find(self.cart_id)
    #cart.update_attribute(:purchased_at, Time.now)
    if cart.tip && cart.tip > 0
      @amount = price_in_cents + tax_in_cents + tip_in_cents
    else
      @amount = price_in_cents + tax_in_cents
    end
    @transaction = transactions.first
    #response = GATEWAY.purchase((price_in_cents + tax_in_cents), credit_card,
    #  purchase_options)

    response = GATEWAY.capture((@amount), @transaction.authorization)
    @transaction.update_attributes(:action => "capture",
      :amount => (@amount), :response => response)

    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    # SWITCH TO ABOVE WHEN LIVE.
    ######## remove when live. ########
    #GATEWAY.void(response.authorization, purchase_options)
    ## uncomment when live
    response.success?
  end

  def price_in_cents
    (cart.total_price*100).round
  end

  def tax_in_cents
    (cart.tax*100).round
  end

  def tip_in_cents
    (self.cart.tip*100).round
  end

  def restaurant
    location.restaurant
  end
=begin
  def restaurant_name
    begin
      restaurant.name
    rescue
      ""
    end
  end
=end
  def price
    total
  end

  def base_total
    total = subtotal + (subtotal * 0.0825)
    return total
  end

  def purchased_at
    cart.purchased_at
  end

  def location
    cart.line_items.first.menu_section_item.menu_section.menu.location
  end

  def location_address
    begin
      "#{cart.line_items.first.menu_section_item.menu_section.menu.location.
        address}, #{cart.line_items.first.menu_section_item.menu_section.menu.
        location.city}, #{cart.line_items.first.menu_section_item.menu_section.
        menu.location.region}"
    rescue
      "No current address on record."
    end
  end

  def deliver_address
    "#{cart.delivery_address.address}, #{cart.delivery_address.city}"
  end

  def delivery_driver
    if cart.delivery_driver
      driver = cart.driver_email ? cart.driver_email : cart.delivery_driver.user.email
    else
      driver = location.delivery_drivers.first ? "#{location.delivery_drivers.first.user.email}" : "n/a"
    end
    return driver
  end

  def delivery_fee
    if cart.delivers
      location.delivery_fee
    else
      "n/a"
    end
  end

  def tip
    if cart.tip && cart.tip > 0
      cart.tip
    else
      "n/a"
    end
  end

  def subtotal
    total_price = 0.0
=begin
    cart.line_items.each do |line_item|
      if !line_item.unit_price.blank?
        total_price += line_item.unit_price.to_f
      elsif
        total_price += line_item.menu_section_item.price.to_f
      else
        total_price += 0
      end
      if line_item.line_item_options
        line_item.line_item_options.each do |line_item_option|
          total_price += (line_item_option.price.to_f * line_item_option.qty.to_f).to_f
        end
      end
    end
=end
    total_price += cart.line_items.to_a.sum(&:full_price).to_f
    return total_price
  end

  def grand_total
    if cart.delivers
      total = subtotal + location.delivery_fee
    else
      total = subtotal
    end
    total += total * 0.0825
    if cart.tip && cart.tip > 0
      total += cart.tip
    end
    return total
  end

  def restaurant_deposit
    location_percentage = location.percentage.to_f / 100
    total = (subtotal * location_percentage) + ((subtotal * location_percentage) * 0.0825)
    return total
  end

  def driver_deposit
    if cart.delivers
      tip = cart.tip ? cart.tip : 0
      total = location.delivery_fee - 0.99 + tip
    else
      total = "n/a"
    end
    return total
  end

  def chowbrowser_deposit
    location_percentage = (100 - location.percentage.to_f) / 100
    if cart.delivers
      total = ((subtotal * location_percentage) + (location.delivery_fee - 2)) + (((subtotal * location_percentage) + location.delivery_fee) * 0.0825)
    else
      total = (subtotal * location_percentage) + ((subtotal * location_percentage) * 0.0825)
    end
    return total
  end

  def assoc_deposit
    location_percentage = (100 - location.percentage.to_f) / 100
    if cart.delivers
      total = ((subtotal * location_percentage) + (location.delivery_fee - 2)) * 0.1
    else
      total = (subtotal * location_percentage) * 0.1
    end
    return total
  end

  def sales_deposit
    location_percentage = (100 - location.percentage.to_f) / 100
    location_percentage = location_percentage - 0.1
    total = (subtotal * location_percentage)
    return total
  end

  def text_location
    location.location_numbers.where("location_numbers.text_number = ?", true)
  end

  def total_wait
    if cart.delivers
      if !cart.delivery_duration.blank?
        response = estimated_wait + cart.delivery_duration
      else
        response = estimated_wait + 20
      end
    else
      response = estimated_wait
    end

    return response
  end

  private

    def purchase_options
      {
        :ip => ip_address,
        :billing_address => {
          :name     => "#{billing_address.first_name} #{billing_address.last_name}",
          :address1 => billing_address.address,
          :city     => billing_address.city,
          :state    => billing_address.state,
          :country  => "US",
          :zip      => billing_address.zip
        },
        :tax => tax_in_cents,
        :order_id => self.id
      }
    end

    def validate_card
      unless credit_card.valid?
        credit_card.errors.full_messages.each do |message|
          errors.add :base, message
        end
      end
    end

    def credit_card
=begin
      @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :type               => card_type,
        :number             => card_number,
        :verification_value => card_verification,
        :month              => card_expires_on.month,
        :year               => card_expires_on.year,
        :first_name         => billing_address.first_name,
        :last_name          => billing_address.last_name
      )
=end
      @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :brand              => card_type,
        :number             => card_number,
        :verification_value => card_verification,
        :month              => card_expires_on.month,
        :year               => card_expires_on.year,
        :first_name         => billing_address.first_name,
        :last_name          => billing_address.last_name
      )
    end

    def total
      total_price = 0.0
      cart.line_items.each do |line_item|
        if !line_item.unit_price.blank?
          total_price += line_item.unit_price.to_f
          if line_item.line_item_options
            line_item.line_item_options.each do |line_item_option|
              total_price += line_item_option.price.to_f
            end
          end
        elsif line_item.menu_section_item
          total_price += line_item.menu_section_item.price.to_f
          if line_item.menu_item_options
            line_item.menu_item_options.each do |menu_item_option|
              total_price += menu_item_option.price.to_f
            end
          end
        else
          total_price += 0
        end
      end
      tax = total_price.to_f * 0.0825
      total_price = total_price + tax
      if tip
        total_price = total_price.to_f + tip.to_f
      end
      return total_price
    end
end
