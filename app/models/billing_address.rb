class BillingAddress < ActiveRecord::Base
  belongs_to :order
  validates :first_name, :last_name, :address, :city, :state, :zip, :presence => true
  validates :address, :city, :state, :length => { :in => 1..250 }
  validates :first_name, :last_name, :length => { :in => 1..125 }
  validates :zip, :length => { :in => 1..100 }

  #def self.country=(country)
  #  write_attribute(:country, "US")
  #end
end
