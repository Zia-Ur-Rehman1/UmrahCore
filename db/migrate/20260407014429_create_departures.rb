class CreateDepartures < ActiveRecord::Migration[7.0]
  def change
    create_table :departures do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.date :departure_date, null: false
      t.date :return_date
      t.integer :capacity, null: false, default: 0
      t.integer :reserved_count, null: false, default: 0
      t.integer :confirmed_count, null: false, default: 0
      t.datetime :fare_lock_deadline
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps null: false
    end

    add_index :departures, [:tenant_id, :departure_date]
  end
end
