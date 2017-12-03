class Trip < ApplicationRecord
  include AASM
  belongs_to :car
  belongs_to :parking, optional: true
  has_one :account, through: :car
  before_create :set_parking

  validates_presence_of :destination_latitude, :destination_longitude

  scope :parked_or_reserved, -> () do
    where(
      state: [
        :reserved,
        :parked
      ]
    )
  end

  aasm column: :state do
    state :planned, initial: true
    state :reserved
    state :parked
    state :unparked
    state :cancelled

    event :reserve do
      before do
        if self.parking.free_spaces(car.account.disabled) <= 0
          self.parking = nearest_parking
        end
      end

      after do
        self.reserved_at = DateTime.now
        save!
      end
      transitions from: :planned, to: :reserved
    end

    event :park do
      after do |duration|
        self.reserved_duration = duration
        self.parked_at = DateTime.now
        save!
      end
      transitions from: :reserved, to: :parked
    end

    event :cancel do
      after do
        self.cancelled_at = DateTime.now
        save!
      end
      transitions from: :planned, to: :cancelled
      transitions from: [:reserved], to: :cancelled, after: :charge_or_cancel!
    end

    event :unpark do
      after do
        self.unparked_at = DateTime.now
        save!
      end
      transitions from: [:parked, :expired], to: :unparked, after: :charge!
    end

    event :expire do
      after do
        # Call the cops
      end
      transitions from: :parked, to: :expired
    end
  end

  def charge!
    # Charge using the Mundipagg API
  end

  def charge_or_cancel!
  end

  def set_parking
    self.parking = nearest_parking
  end

  def destination
    Coord.new(destination_latitude, destination_longitude)
  end

  def nearest_parking
    Parking
      .available_lots(destination, 1000)
      .select{ |p| p.spaces > p.trips.parked_or_reserved.count }
      .first
  end
end
