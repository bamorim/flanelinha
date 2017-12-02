class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.references :car, foreign_key: true
      t.float :destination_longitude
      t.float :destination_latitude
      t.references :planned_parking, foreign_key: { to_table: :parkings }
      t.references :reserved_parking, foreign_key: { to_table: :parkings }
      t.datetime :reserved_at
      t.datetime :parked_at
      t.datetime :unparked_at
      t.datetime :cancelled_at
      t.integer :reserved_duration

      t.timestamps
    end
  end
end
