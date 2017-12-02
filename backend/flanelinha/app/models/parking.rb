class Parking < ApplicationRecord
  # get all possible lots using user-defined threshold
  def self.available_lots(destination, threshold)
    Parkings.all.select { |p| destination.distance(p.coord) <= threshold }
  end

  def coord
    Coord.new(latitude, longitude)
  end

  private :parking_search
end
