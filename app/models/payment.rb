class Payment < ApplicationRecord
  include TenantOwned

  belongs_to :booking

  has_many :ledger_entries, dependent: :restrict_with_error

  enum status: {
    pending: 0,
    succeeded: 1,
    refunded: 2,
    failed: 3
  }, _prefix: true

  before_validation :apply_defaults

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :currency, :status, :payment_method, presence: true
  validate :booking_belongs_to_current_tenant

  private

  def apply_defaults
    self.status ||= :succeeded
    self.currency = booking&.currency || "USD" if currency.blank?
    self.paid_at ||= Time.current
  end

  def booking_belongs_to_current_tenant
    return if booking.blank? || tenant.blank?
    return if booking.tenant_id == tenant_id

    errors.add(:booking, "must belong to the current tenant")
  end
end
