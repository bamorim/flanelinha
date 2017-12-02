class Account < ApplicationRecord
  has_many :cars
  has_many :trips, through: :cars

  validates_presence_of :email, :document_number, :disabled
end
