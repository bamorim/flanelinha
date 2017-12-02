class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :password_hash
      t.string :document_number
      t.string :document_type
      t.boolean :disabled

      t.timestamps
    end
  end
end
