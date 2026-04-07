platform_admin = User.find_or_initialize_by(email: "platform.admin@umrahopspro.test")
platform_admin.assign_attributes(
  full_name: "Platform Admin",
  password: "Password123!",
  password_confirmation: "Password123!",
  platform_admin: true,
  status: :active,
  tenant: nil
)
platform_admin.save!

demo_result = Tenants::Provisioner.call(
  tenant_attributes: {
    name: "Demo Travels",
    slug: "demo",
    tier: :standard,
    isolation_model: :row,
    support_email: "support@demotravels.test",
    region: "PK"
  },
  owner_attributes: {
    full_name: "Demo Owner",
    email: "owner@demotravels.test",
    password: "Password123!",
    password_confirmation: "Password123!",
    role: :owner
  }
)

unless demo_result.success?
  demo_tenant = Tenant.find_or_initialize_by(slug: "demo")
  demo_tenant.assign_attributes(
    name: "Demo Travels",
    tier: :standard,
    isolation_model: :row,
    support_email: "support@demotravels.test",
    region: "PK"
  )
  demo_tenant.save!

  demo_tenant.domain_mappings.find_or_create_by!(host: "demo.lvh.me") do |mapping|
    mapping.kind = :subdomain
    mapping.primary = true
    mapping.verified_at = Time.current
  end

  demo_owner = demo_tenant.users.find_or_initialize_by(email: "owner@demotravels.test")
  demo_owner.assign_attributes(
    full_name: "Demo Owner",
    password: "Password123!",
    password_confirmation: "Password123!",
    role: :owner,
    status: :active
  )
  demo_owner.save!
end

demo_tenant = Tenant.find_by!(slug: "demo")
demo_finance = demo_tenant.users.find_or_initialize_by(email: "finance@demotravels.test")
demo_finance.assign_attributes(
  full_name: "Demo Finance",
  password: "Password123!",
  password_confirmation: "Password123!",
  role: :finance_officer,
  status: :active
)
demo_finance.save!

demo_support = demo_tenant.users.find_or_initialize_by(email: "support@demotravels.test")
demo_support.assign_attributes(
  full_name: "Demo Support",
  password: "Password123!",
  password_confirmation: "Password123!",
  role: :support_agent,
  status: :active
)
demo_support.save!

demo_product = demo_tenant.products.find_or_initialize_by(name: "Premium Spring Umrah")
demo_product.assign_attributes(
  description: "Makkah and Madinah package with guided support and hotel stays.",
  product_type: :umrah_package,
  base_price_cents: 245_000,
  currency: "USD",
  duration_nights: 10,
  inclusions: "Visa support, hotels, ground transport, guided itinerary",
  status: :published,
  b2c_enabled: true
)
demo_product.save!

demo_tenant.departures.find_or_create_by!(
  product: demo_product,
  departure_date: Date.new(2026, 11, 15)
) do |departure|
  departure.return_date = Date.new(2026, 11, 25)
  departure.capacity = 40
  departure.reserved_count = 8
  departure.confirmed_count = 6
  departure.fare_lock_deadline = 30.days.from_now
  departure.status = :published
  departure.notes = "Early allocation batch"
end

demo_departure = demo_tenant.departures.find_by!(product: demo_product, departure_date: Date.new(2026, 11, 15))
demo_booking = demo_tenant.bookings.find_or_initialize_by(booking_ref: "DEM-260407-A1")
demo_booking.assign_attributes(
  product: demo_product,
  departure: demo_departure,
  lead_traveler_name: "Amina Rahman",
  lead_traveler_email: "amina@example.test",
  status: :pending_payment,
  travelers_count: 2,
  total_price_cents: 490_000,
  amount_paid_cents: 150_000,
  outstanding_cents: 340_000,
  currency: "USD",
  payment_plan: "Installment",
  idempotency_key: "seed-booking-demo",
  notes: "Requires quad rooming"
)
demo_booking.save!

lead_traveler = demo_booking.travelers.find_or_initialize_by(full_name: "Amina Rahman")
lead_traveler.assign_attributes(
  tenant: demo_tenant,
  passport_number: "PK1234567",
  date_of_birth: Date.new(1992, 5, 4),
  status: :verified,
  notes: "Lead traveler"
)
lead_traveler.save!

second_traveler = demo_booking.travelers.find_or_initialize_by(full_name: "Zayan Rahman")
second_traveler.assign_attributes(
  tenant: demo_tenant,
  passport_number: "PK7654321",
  date_of_birth: Date.new(2010, 8, 14),
  status: :documents_pending
)
second_traveler.save!

seed_payment = demo_booking.payments.find_or_initialize_by(external_reference: "SEED-PAY-001")
seed_payment.assign_attributes(
  tenant: demo_tenant,
  amount_cents: 150_000,
  currency: "USD",
  status: :succeeded,
  payment_method: "manual_transfer",
  paid_at: Time.current - 2.days,
  notes: "Initial deposit"
)
seed_payment.save!

seed_entry = demo_booking.ledger_entries.find_or_initialize_by(idempotency_key: "seed-ledger-demo")
seed_entry.assign_attributes(
  tenant: demo_tenant,
  payment: seed_payment,
  entry_type: :payment_receipt,
  debit_account: "Cash",
  credit_account: "Deferred Revenue",
  amount_cents: 150_000,
  currency: "USD",
  posted_at: seed_payment.paid_at,
  description: "Seed deposit for demo booking"
)
seed_entry.save!

support_case = demo_tenant.support_cases.find_or_initialize_by(case_ref: "CASE-260407-D1")
support_case.assign_attributes(
  booking: demo_booking,
  subject: "Need rooming confirmation",
  contact_name: "Amina Rahman",
  contact_email: "amina@example.test",
  priority: :high,
  status: :open,
  source: "whatsapp",
  assigned_user: demo_support,
  sla_due_at: 8.hours.from_now
)
support_case.save!

initial_case_message = support_case.case_messages.find_or_initialize_by(body: "Customer asked whether quad rooming is confirmed.")
initial_case_message.assign_attributes(
  tenant: demo_tenant,
  user: demo_support,
  direction: :inbound,
  sent_at: Time.current - 3.hours
)
initial_case_message.save!
