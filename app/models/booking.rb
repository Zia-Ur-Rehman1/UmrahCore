class Booking < ApplicationRecord
  include TenantOwned

  belongs_to :product
  belongs_to :departure
  belongs_to :customer_user, class_name: "User", optional: true, inverse_of: :customer_bookings
  belongs_to :group_leader_user, class_name: "User", optional: true, inverse_of: :group_leader_bookings

  has_many :ledger_entries, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :support_cases, dependent: :nullify
  has_many :travelers, dependent: :destroy

  enum status: {
    draft: 0,
    pending_payment: 1,
    confirmed: 2,
    cancelled: 3,
    completed: 4
  }, _prefix: true

  before_validation :apply_defaults
  before_validation :normalize_email
  before_validation :generate_identifiers, on: :create

  validates :booking_ref, :lead_traveler_name, :lead_traveler_email, :status, :currency, :idempotency_key, presence: true
  validates :lead_traveler_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :travelers_count, numericality: { greater_than: 0 }
  validates :total_price_cents, :amount_paid_cents, :outstanding_cents, numericality: { greater_than_or_equal_to: 0 }
  validate :product_and_departure_belong_to_tenant
  validate :departure_matches_product
  validate :portal_users_belong_to_tenant
  validate :portal_user_roles_are_supported

  scope :for_portal_user, ->(user) do
    return none if user.blank?

    where(customer_user_id: user.id).or(where(group_leader_user_id: user.id))
  end

  def recalculate_payment_state!
    self.outstanding_cents = [total_price_cents - amount_paid_cents, 0].max
    self.status = outstanding_cents.zero? ? :confirmed : :pending_payment
  end

  def visible_to_portal_user?(user)
    user.present? && [customer_user_id, group_leader_user_id].compact.include?(user.id)
  end

  private

  def apply_defaults
    self.status ||= :draft
    self.travelers_count ||= 1
    self.currency = product&.currency || "USD" if currency.blank?
    self.total_price_cents ||= 0
    self.amount_paid_cents ||= 0
    self.outstanding_cents ||= total_price_cents
  end

  def normalize_email
    self.lead_traveler_email = lead_traveler_email.to_s.downcase.strip
  end

  def generate_identifiers
    self.booking_ref ||= "#{tenant&.slug.to_s.upcase.first(3)}-#{Time.current.strftime('%y%m%d')}-#{SecureRandom.hex(2).upcase}"
    self.idempotency_key ||= SecureRandom.uuid
  end

  def product_and_departure_belong_to_tenant
    if product.present? && tenant.present? && product.tenant_id != tenant_id
      errors.add(:product, "must belong to the current tenant")
    end

    if departure.present? && tenant.present? && departure.tenant_id != tenant_id
      errors.add(:departure, "must belong to the current tenant")
    end
  end

  def departure_matches_product
    return if product.blank? || departure.blank?
    return if departure.product_id == product_id

    errors.add(:departure, "must belong to the selected product")
  end

  def portal_users_belong_to_tenant
    {
      customer_user: customer_user,
      group_leader_user: group_leader_user
    }.each do |attribute, portal_user|
      next if portal_user.blank? || tenant.blank? || portal_user.tenant_id == tenant_id

      errors.add(attribute, "must belong to the current tenant")
    end
  end

  def portal_user_roles_are_supported
    if customer_user.present? && !customer_user.role_customer?
      errors.add(:customer_user, "must have the customer role")
    end

    if group_leader_user.present? && !group_leader_user.role_group_leader?
      errors.add(:group_leader_user, "must have the group leader role")
    end
  end
end
