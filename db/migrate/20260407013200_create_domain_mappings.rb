class CreateDomainMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_mappings do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :host, null: false
      t.integer :kind, null: false, default: 0
      t.boolean :primary, null: false, default: false
      t.datetime :verified_at

      t.timestamps null: false
    end

    add_index :domain_mappings, :host, unique: true
    add_index :domain_mappings, :tenant_id,
              unique: true,
              where: "\"primary\" = true",
              name: "index_domain_mappings_on_tenant_primary"
  end
end
