class Coord
  attr_reader :lat, :long

  def initialize(lat,long)
    @lat, @long = lat, long
  end

  # compute approximate distance on earth surfface
  def distance(o)
    d_phi = (lat - o.lat) * 0.5
    d_lambda = (long - o.long) * 0.5
    a = (Math.sin(d_phi) ** 2) + Math.cos(lat) * Math.cos(o.lat) * (Math.sin(d_lambda) ** 2)
    c  = 2 * Math.atan2(a ** 0.5, (1 - a) ** 0.5) ** 2
    r = 6.371
    return r * c
  end
end
