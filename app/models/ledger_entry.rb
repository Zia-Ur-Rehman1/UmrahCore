class LedgerEntry < ApplicationRecord
  include TenantOwned

  belongs_to :booking
  belongs_to :payment

  enum entry_type: {
    payment_receipt: 0,
    refund: 1,
    reversal: 2
  }, _prefix: true

  before_validation :apply_defaults

  validates :entry_type, :debit_account, :credit_account, :currency, :posted_at, :idempotency_key, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }

  private

  def apply_defaults
    self.entry_type ||= :payment_receipt
    self.currency = payment&.currency || booking&.currency || "USD" if currency.blank?
    self.posted_at ||= Time.current
    self.idempotency_key ||= SecureRandom.uuid
  end
end
