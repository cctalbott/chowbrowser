class Session < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :orders

  def self.sweep(time = 1.hour)
    time = time.split.inject { |count, unit|
      count.to_i.send(unit)
    } if time.is_a?(String)

    delete_all "updated_at < '#{time.ago.to_s(:db)}' OR
      created_at < '#{2.days.ago.to_s(:db)}'"
  end
end
