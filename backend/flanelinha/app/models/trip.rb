class Trip < ApplicationRecord
  include AASM
  belongs_to :car
  has_one :account, through: :car
  belongs_to :planned_parking, class_name: "Parking", optional: true
  belongs_to :reserved_parking, class_name: "Parking", optional: true

  validates_presence_of :destination_latitude, :destination_longitude

  aasm column: :state do
    state :planned, initial: true
    state :reserving
    state :reserving_failed
    state :reserved
    state :parking
    state :parking_failed
    state :parked
    state :unparked
    state :cancelled

    event :reserve do
      after do
        # Schedule authorization job
      end
      transitions from: :planned, to: :reserving
    end

    event :confirm_reservation do
      after do
        self.reserved_parking = planned_parking
        self.reserved_at = DateTime.now
        save!
      end
      transitions from: [:reserving, :reserving_failed], to: :reserved
    end

    event :park do
      after do |duration|
        # Schedule authorization job
      end
      transitions from: :reserved, to: :parking
    end

    event :confirm_park do
      after do
        self.parked_at = DateTime.now
        save!
      end
      transitions from: [:parking, :parking_failed], to: :parked
    end

    event :fail_payment do
      transitions from: :parking, to: :parking_failed
      transitions from: :reserving, to: :reserving_failed
    end

    event :cancel do
      after do
        self.cancelled_at = DateTime.now
        save!
      end
      transitions from: :planned, to: :cancelled
      transitions from: [:reserving, :reserved], to: :cancelled, after: :charge_or_cancel!
    end

    event :unpark do
      after do
        # Make the Charge
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
  end

  def charge_or_cancel!
  end
end
