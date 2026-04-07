class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :product_type, null: false, default: 0
      t.integer :base_price_cents, null: false, default: 0
      t.string :currency, null: false, default: "USD"
      t.integer :duration_nights, null: false, default: 0
      t.text :inclusions
      t.integer :status, null: false, default: 0
      t.boolean :b2c_enabled, null: false, default: false

      t.timestamps null: false
    end

    add_index :products, [:tenant_id, :name]
  end
end
