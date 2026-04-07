class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :departure, null: false, foreign_key: true
      t.string :booking_ref, null: false
      t.string :lead_traveler_name, null: false
      t.string :lead_traveler_email, null: false
      t.integer :status, null: false, default: 0
      t.integer :travelers_count, null: false, default: 1
      t.integer :total_price_cents, null: false, default: 0
      t.integer :amount_paid_cents, null: false, default: 0
      t.integer :outstanding_cents, null: false, default: 0
      t.string :currency, null: false, default: "USD"
      t.string :payment_plan
      t.string :idempotency_key, null: false
      t.text :notes

      t.timestamps null: false
    end

    add_index :bookings, :booking_ref, unique: true
    add_index :bookings, :idempotency_key, unique: true
  end
end
