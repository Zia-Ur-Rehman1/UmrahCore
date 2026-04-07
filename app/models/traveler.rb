class Traveler < ApplicationRecord
  include TenantOwned

  belongs_to :booking

  enum status: {
    draft: 0,
    verified: 1,
    documents_pending: 2
  }, _prefix: true

  before_validation :apply_defaults

  validates :full_name, :status, presence: true
  validate :booking_belongs_to_current_tenant

  private

  def apply_defaults
    self.status ||= :draft
  end

  def booking_belongs_to_current_tenant
    return if booking.blank? || tenant.blank?
    return if booking.tenant_id == tenant_id

    errors.add(:booking, "must belong to the current tenant")
  end
end
