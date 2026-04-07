# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_04_07_071000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "product_id", null: false
    t.bigint "departure_id", null: false
    t.string "booking_ref", null: false
    t.string "lead_traveler_name", null: false
    t.string "lead_traveler_email", null: false
    t.integer "status", default: 0, null: false
    t.integer "travelers_count", default: 1, null: false
    t.integer "total_price_cents", default: 0, null: false
    t.integer "amount_paid_cents", default: 0, null: false
    t.integer "outstanding_cents", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.string "payment_plan"
    t.string "idempotency_key", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_user_id"
    t.bigint "group_leader_user_id"
    t.index ["booking_ref"], name: "index_bookings_on_booking_ref", unique: true
    t.index ["customer_user_id"], name: "index_bookings_on_customer_user_id"
    t.index ["departure_id"], name: "index_bookings_on_departure_id"
    t.index ["group_leader_user_id"], name: "index_bookings_on_group_leader_user_id"
    t.index ["idempotency_key"], name: "index_bookings_on_idempotency_key", unique: true
    t.index ["product_id"], name: "index_bookings_on_product_id"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
  end

  create_table "case_messages", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "support_case_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.integer "direction", default: 0, null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["support_case_id"], name: "index_case_messages_on_support_case_id"
    t.index ["tenant_id"], name: "index_case_messages_on_tenant_id"
    t.index ["user_id"], name: "index_case_messages_on_user_id"
  end

  create_table "departures", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "product_id", null: false
    t.date "departure_date", null: false
    t.date "return_date"
    t.integer "capacity", default: 0, null: false
    t.integer "reserved_count", default: 0, null: false
    t.integer "confirmed_count", default: 0, null: false
    t.datetime "fare_lock_deadline"
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_departures_on_product_id"
    t.index ["tenant_id", "departure_date"], name: "index_departures_on_tenant_id_and_departure_date"
    t.index ["tenant_id"], name: "index_departures_on_tenant_id"
  end

  create_table "domain_mappings", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "host", null: false
    t.integer "kind", default: 0, null: false
    t.boolean "primary", default: false, null: false
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host"], name: "index_domain_mappings_on_host", unique: true
    t.index ["tenant_id"], name: "index_domain_mappings_on_tenant_id"
    t.index ["tenant_id"], name: "index_domain_mappings_on_tenant_primary", unique: true, where: "(\"primary\" = true)"
  end

  create_table "ledger_entries", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "booking_id", null: false
    t.bigint "payment_id", null: false
    t.integer "entry_type", default: 0, null: false
    t.string "debit_account", null: false
    t.string "credit_account", null: false
    t.integer "amount_cents", null: false
    t.string "currency", default: "USD", null: false
    t.datetime "posted_at", null: false
    t.text "description"
    t.string "idempotency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_ledger_entries_on_booking_id"
    t.index ["idempotency_key"], name: "index_ledger_entries_on_idempotency_key", unique: true
    t.index ["payment_id"], name: "index_ledger_entries_on_payment_id"
    t.index ["tenant_id"], name: "index_ledger_entries_on_tenant_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "booking_id", null: false
    t.integer "amount_cents", null: false
    t.string "currency", default: "USD", null: false
    t.integer "status", default: 0, null: false
    t.string "payment_method", null: false
    t.string "external_reference"
    t.datetime "paid_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "product_type", default: 0, null: false
    t.integer "base_price_cents", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.integer "duration_nights", default: 0, null: false
    t.text "inclusions"
    t.integer "status", default: 0, null: false
    t.boolean "b2c_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "name"], name: "index_products_on_tenant_id_and_name"
    t.index ["tenant_id"], name: "index_products_on_tenant_id"
  end

  create_table "support_cases", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "booking_id"
    t.string "case_ref", null: false
    t.string "subject", null: false
    t.string "contact_name", null: false
    t.string "contact_email"
    t.integer "priority", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.string "source", default: "web", null: false
    t.bigint "assigned_user_id"
    t.datetime "sla_due_at"
    t.datetime "first_response_at"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_user_id"], name: "index_support_cases_on_assigned_user_id"
    t.index ["booking_id"], name: "index_support_cases_on_booking_id"
    t.index ["case_ref"], name: "index_support_cases_on_case_ref", unique: true
    t.index ["tenant_id"], name: "index_support_cases_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.integer "status", default: 1, null: false
    t.integer "tier", default: 0, null: false
    t.integer "isolation_model", default: 0, null: false
    t.string "db_schema_name"
    t.string "region"
    t.jsonb "settings", default: {}, null: false
    t.string "support_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tenants_on_slug", unique: true
  end

  create_table "travelers", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "booking_id", null: false
    t.string "full_name", null: false
    t.string "passport_number"
    t.date "date_of_birth"
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_travelers_on_booking_id"
    t.index ["tenant_id"], name: "index_travelers_on_tenant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "tenant_id"
    t.string "full_name", null: false
    t.string "phone_e164"
    t.integer "status", default: 1, null: false
    t.integer "role"
    t.boolean "platform_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "bookings", "departures"
  add_foreign_key "bookings", "products"
  add_foreign_key "bookings", "tenants"
  add_foreign_key "bookings", "users", column: "customer_user_id"
  add_foreign_key "bookings", "users", column: "group_leader_user_id"
  add_foreign_key "case_messages", "support_cases"
  add_foreign_key "case_messages", "tenants"
  add_foreign_key "case_messages", "users"
  add_foreign_key "departures", "products"
  add_foreign_key "departures", "tenants"
  add_foreign_key "domain_mappings", "tenants"
  add_foreign_key "ledger_entries", "bookings"
  add_foreign_key "ledger_entries", "payments"
  add_foreign_key "ledger_entries", "tenants"
  add_foreign_key "payments", "bookings"
  add_foreign_key "payments", "tenants"
  add_foreign_key "products", "tenants"
  add_foreign_key "support_cases", "bookings"
  add_foreign_key "support_cases", "tenants"
  add_foreign_key "support_cases", "users", column: "assigned_user_id"
  add_foreign_key "travelers", "bookings"
  add_foreign_key "travelers", "tenants"
  add_foreign_key "users", "tenants"
end
