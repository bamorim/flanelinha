class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|
      t.string :name
      t.integer :spaces
      t.integer :disabled_spaces
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
