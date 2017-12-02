class Car < ApplicationRecord
  belongs_to :account
  has_many :trips
end
