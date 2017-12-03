class Account < ApplicationRecord
  has_many :cars
  has_many :trips, through: :cars
  has_one :card, dependent: :destroy

  validates_presence_of :email, :document_number, :name

  def as_json(opts = {})
    super(
      opts.merge(
        include: {
          card: {
            only: [:last_digits, :id],
            methods: :valid_thru
          }
        }
      )
    )
  end
end
