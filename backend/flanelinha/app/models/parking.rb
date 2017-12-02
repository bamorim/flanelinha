class Parking < ApplicationRecord

  def point 
    [self.latitude, self.longitude]
  end

  # get all possible lots using user-defined threshold
  def available_lots(destination, threshold, dist)
    parkings = Parkings.all.sort! {|x, y| x.latitude <= y.latitude and x.longitude < y.longitude}
    ind = parking_search(destination, parkings)
    i_set = new Array()

    def grow_indices (increment, i)
      while dist parkings[i],destination < threshold
        i_set.append(parkings[i])
        i += increment
      end
    end

    grow_indices 1, ind
    grow_indices -1, ind - 1
    i_set
  end

  # find the closest parking lot comparing to the point
  def parking_search(point, list)
    halfway = list.lenght / 2
    if point >= list[halfway].point and point < list[halfway + 1].point
      return halfway
    elsif point <= list[halfway].point and point > list[halfway - 1].point
      return halfway
    elsif point < list[halfway - 1].point
      return parking_search point,list[0..halfway]
    else
      return parking_search point,list[halfway..-1]
    end
  end

  private :parking_search
end
