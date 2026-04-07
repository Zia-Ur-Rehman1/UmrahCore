class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.integer :status, null: false, default: 1
      t.integer :tier, null: false, default: 0
      t.integer :isolation_model, null: false, default: 0
      t.string :db_schema_name
      t.string :region
      t.jsonb :settings, null: false, default: {}
      t.string :support_email

      t.timestamps null: false
    end

    add_index :tenants, :slug, unique: true
  end
end
