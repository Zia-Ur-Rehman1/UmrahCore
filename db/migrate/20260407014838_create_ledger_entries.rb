class CreateLedgerEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :ledger_entries do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true
      t.integer :entry_type, null: false, default: 0
      t.string :debit_account, null: false
      t.string :credit_account, null: false
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.datetime :posted_at, null: false
      t.text :description
      t.string :idempotency_key, null: false

      t.timestamps null: false
    end

    add_index :ledger_entries, :idempotency_key, unique: true
  end
end
