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

  def nearest_parking(latitude, longitude)

    def dist(p1, p2) # compute approximate distance on earth surfface
      d_phi = (p1[0] - p2[0]) * 0.5
      d_lambda = (p1[1] - p2[1]) * 0.5
      a = (Math.sin(d_phi) ** 2) + Math.cos(p1[0]) * Math.cos(p2[0]) * (Math.sin(d_lambda) ** 2)
      c  = 2 * Math.atan(a ** 0.5, (1 - a) ** 0.5) ** 2
      r = 6.371
      return r * c
    end

    strong_set = evaluate_strong_set(destination, parkings, threshold, dist)
    i = 0
    while strong_set[i].not_free
      i += 1
    end
    return strong_set[i]
  end
end
