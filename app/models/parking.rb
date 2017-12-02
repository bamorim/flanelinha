class Parking < ApplicationRecord
  has_many :trips

  def self.available_lots(destination, threshold)
    puts threshold
    all
      .sort_by{ |p| destination.distance(p.coord) }
      .select{ |p| destination.distance(p.coord) <= threshold }
  end

  def coord
    Coord.new(latitude, longitude)
  end

  def free_spaces(disabled)
    (send(disabled ? :disabled_spaces : :spaces) || 0) - used_spaces(disabled)
  end

  def used_spaces(disabled)
    trips.parked_or_reserved.includes(car: :account).where(accounts: {disabled: disabled}).count
  end

  def as_json(*args)
    super(*args)
      .merge(free_spaces: free_spaces(false), free_disabled_spaces: free_spaces(true))
  end
end
