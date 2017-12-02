class Trip < ApplicationRecord
  belongs_to :car
  belongs_to :planned_parking, class_name: "Parking", optional: true
  belongs_to :reserved_parking, class_name: "Parking", optional: true
end
