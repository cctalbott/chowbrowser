class DeliveryDriver < ActiveRecord::Base
  belongs_to :user
  has_many :delivery_hours, :dependent => :destroy
  has_and_belongs_to_many :locations
  accepts_nested_attributes_for :delivery_hours, :allow_destroy => true
  validates :phone, :presence => true, :length => { :in => 1..50 },
    :format => { :with => /^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$/ }
  validates_associated :delivery_hours

  def self.dd_emails
    @dd_emails = joins(:user).select("email").where("email NOT IN('redacted@domain.com', 'redacted@domain.com', 'redacted@domain.com', 'redacted@domain.com')")
    @dd_emails = @dd_emails.select {|dd| dd.is_delivering?}
    @dd_emails = @dd_emails.map! {|dd| dd.email}
    @dd_emails = @dd_emails.push('redacted@domain.com', 'redacted@domain.com', 'redacted@domain.com', 'redacted@domain.com')
    return @dd_emails
  end

  def driver_title
    user ? user.email : phone
  end

  def is_delivering?
    @delivering = false
    @current_time = Time.now.min + (Time.now.hour * 60)
    @current_day = Time.now.days_to_week_start(:sunday)
    if delivery_hours && delivery_hours.length > 0
      delivery_hours.each do |delivery_hour|
        delivery_day = delivery_hour.day
        delivery_start = (delivery_hour.start_hr * 60) + delivery_hour.start_min
        delivery_end = (delivery_hour.end_hr * 60) + delivery_hour.end_min
        if delivery_day == @current_day
          if(delivery_start <= @current_time && delivery_end >= @current_time)
            @delivering = true
          end
        end
      end
    end
    return @delivering
  end
end
