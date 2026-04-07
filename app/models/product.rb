class Product < ApplicationRecord
  include TenantOwned

  has_many :bookings, dependent: :restrict_with_error
  has_many :departures, dependent: :destroy

  enum product_type: {
    umrah_package: 0,
    group_tour: 1,
    hotel_only: 2
  }, _prefix: true

  enum status: {
    draft: 0,
    published: 1,
    archived: 2
  }, _prefix: true

  before_validation :apply_defaults
  before_validation :normalize_currency

  validates :name, presence: true
  validates :product_type, :status, presence: true
  validates :base_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_nights, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true, length: { is: 3 }

  private

  def apply_defaults
    self.product_type ||= :umrah_package
    self.status ||= :draft
    self.currency = "USD" if currency.blank?
    self.b2c_enabled = false if b2c_enabled.nil?
  end

  def normalize_currency
    self.currency = currency.to_s.upcase if currency.present?
  end
end
