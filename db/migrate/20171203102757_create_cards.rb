class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :last_digits
      t.integer :valid_year
      t.integer :valid_month
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
