class CreateSupportCases < ActiveRecord::Migration[7.0]
  def change
    create_table :support_cases do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :booking, foreign_key: true
      t.string :case_ref, null: false
      t.string :subject, null: false
      t.string :contact_name, null: false
      t.string :contact_email
      t.integer :priority, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.string :source, null: false, default: "web"
      t.references :assigned_user, foreign_key: { to_table: :users }
      t.datetime :sla_due_at
      t.datetime :first_response_at
      t.datetime :resolved_at

      t.timestamps null: false
    end

    add_index :support_cases, :case_ref, unique: true
  end
end
