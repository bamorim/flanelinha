class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.references :account, foreign_key: true
      t.string :plate_number
      t.string :nickname

      t.timestamps
    end
  end
end
