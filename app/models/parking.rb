class Parking < ApplicationRecord
  has_many :trips, foreign_key: :reserved_parking
  # get all possible lots using user-defined threshold
  def self.available_lots(destination, threshold)
    puts threshold
    all
      .sort_by{ |p| destination.distance(p.coord) }
      .select{ |p| destination.distance(p.coord) <= threshold }
  end

  def coord
    Coord.new(latitude, longitude)
  end
end
