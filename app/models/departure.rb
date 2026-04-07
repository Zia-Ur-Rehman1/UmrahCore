class Departure < ApplicationRecord
  include TenantOwned

  has_many :bookings, dependent: :restrict_with_error
  belongs_to :product

  enum status: {
    draft: 0,
    published: 1,
    sold_out: 2,
    departed: 3,
    cancelled: 4
  }, _prefix: true

  before_validation :apply_defaults
  validate :product_belongs_to_same_tenant
  validate :return_date_not_before_departure

  validates :departure_date, presence: true
  validates :capacity, numericality: { greater_than_or_equal_to: 0 }
  validates :reserved_count, :confirmed_count, numericality: { greater_than_or_equal_to: 0 }

  private

  def apply_defaults
    self.status ||= :draft
    self.capacity ||= 0
    self.reserved_count ||= 0
    self.confirmed_count ||= 0
  end

  def product_belongs_to_same_tenant
    return if product.blank? || tenant.blank?
    return if product.tenant_id == tenant_id

    errors.add(:product, "must belong to the current tenant")
  end

  def return_date_not_before_departure
    return if return_date.blank? || departure_date.blank?
    return if return_date >= departure_date

    errors.add(:return_date, "must be on or after the departure date")
  end
end
