class CreateTravelers < ActiveRecord::Migration[7.0]
  def change
    create_table :travelers do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :passport_number
      t.date :date_of_birth
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps null: false
    end
  end
end
