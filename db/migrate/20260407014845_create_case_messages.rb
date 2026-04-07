class CreateCaseMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :case_messages do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :support_case, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :direction, null: false, default: 0
      t.datetime :sent_at

      t.timestamps null: false
    end
  end
end
