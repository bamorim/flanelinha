# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
account = Account.create!(
  email: "bamorim2@gmail.com",
  password_hash: "plaintext",
  document_type: "cpf",
  document_number: "37853732791",
  name: "Bernardo Amorim"
)

account.cars.create!(
  plate_number: "ABC1234",
  nickname: "Carro Mae"
)

Parking.create!(
  name: "Engenhao 1",
  latitude: -22.8944452,
  longitude: -43.2943711,
  spaces: 10,
  disabled_spaces: 2
)

Parking.create!(
  name: "Engenhao 2",
  latitude: -22.89278,
  longitude: -43.2931798,
  spaces: 20,
  disabled_spaces: 1
)

Parking.create!(
  name: "Engenhao 3",
  latitude: -22.8928607,
  longitude: -43.2957455,
  spaces: 5,
  disabled_spaces: 3
)
