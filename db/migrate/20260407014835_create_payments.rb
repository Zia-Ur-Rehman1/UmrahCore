class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.integer :status, null: false, default: 0
      t.string :payment_method, null: false
      t.string :external_reference
      t.datetime :paid_at
      t.text :notes

      t.timestamps null: false
    end
  end
end
