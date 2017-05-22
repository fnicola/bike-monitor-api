class Station < ApplicationRecord
  has_one :location
  has_many :spaces

  def self.timeout_time
    5.minutes
  end
end
