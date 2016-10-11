class Printer < ActiveRecord::Base
  belongs_to :location

  validates :email, :service_no, :model_name, :presence => true,
    :length => { :in => 1..140 }
  validates :email,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
end
