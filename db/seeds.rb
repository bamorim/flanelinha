# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
my_account = Account.create!(
  email: "bamorim2@gmail.com",
  password_hash: "plaintext",
  document_type: "cpf",
  document_number: "37853732791",
  name: "Bernardo Amorim"
)

my_car = my_account.cars.create!(
  plate_number: "ABC-1234",
  nickname: "Carro Mae"
)

Parking.create!(
  name: "Engenhão",
  latitude: -22.8931818,
  longitude: -43.2958403,
  spaces: 10,
  disabled_spaces: 3
)

JSON.parse(File.read(File.join(__dir__,"parkings.json"))).each do |p|
  Parking.create!(p)
end

Trip.transaction do
  parkings = Parking.all

  parkings.shuffle.first(20).each_with_index do |p,i| 
    dt = (21-i).days.ago
    trip = my_car.trips.create!(
      created_at: dt,
      updated_at: dt,
      destination_latitude: p.latitude,
      destination_longitude: p.longitude
    )
    trip.reserve!
    trip.park!
    trip.unpark!
  end

  parkings.each do |p|
    acc = Account.create!(
      email: "user#{p.id}@hackathon.com",
      name: "Pessoa #{p.id}",
      document_number: "929283782%03d" % p.id
    )
    car = acc.cars.create!(
      plate_number: "ABC-1%03d" % p.id,
      nickname: "Carro Principal"
    )

    trip = car.trips.create!(
      destination_latitude: p.latitude,
      destination_longitude: p.longitude
    )

    trip.reserve!
    trip.park!
  end
end

