class LocationNumber < ActiveRecord::Base
  belongs_to :location
  validates :phone, :presence => true, :length => { :in => 1..50 },
    :format => { :with => /^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$/ },
    :uniqueness => false
  validates :send_digits_ext, :length => { :in => 1..20 },
    :allow_blank => true
end
