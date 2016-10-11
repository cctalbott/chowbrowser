class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params
  validates :amount, :presence => true, :length => { :in => 1..5 }, :numericality => true
  #validates_associated :order

  def response=(response)
    self.success       = response.success?
    self.authorization = response.authorization
    self.message       = response.message
    self.params        = response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.params        = {}
  end
end
