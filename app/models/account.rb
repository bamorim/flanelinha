class Account < ApplicationRecord
  has_many :cars
  has_many :trips, through: :cars
end
