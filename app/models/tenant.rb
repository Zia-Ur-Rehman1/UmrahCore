class Tenant < ApplicationRecord
  has_many :domain_mappings, dependent: :destroy
  has_many :departures, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :travelers, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :ledger_entries, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :support_cases, dependent: :destroy
  has_many :case_messages, dependent: :destroy
  has_many :users, dependent: :destroy
  has_one :primary_domain_mapping, -> { where(primary: true) }, class_name: "DomainMapping", inverse_of: :tenant

  enum status: {
    provisioning: 0,
    setup: 1,
    active: 2,
    suspended: 3,
    archived: 4
  }, _prefix: true

  enum tier: {
    standard: 0,
    premium: 1,
    enterprise: 2
  }, _prefix: true

  enum isolation_model: {
    row: 0,
    schema: 1,
    database: 2
  }, _prefix: true

  before_validation :normalize_slug
  before_validation :apply_defaults

  validates :slug, presence: true,
                   uniqueness: true,
                   format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "must use lowercase letters, numbers, and dashes only" }
  validates :name, presence: true
  validates :status, :tier, :isolation_model, presence: true
  validates :support_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def primary_host
    primary_domain_mapping&.host
  end

  private

  def normalize_slug
    self.slug = slug.to_s.parameterize if slug.present?
  end

  def apply_defaults
    self.status ||= :setup
    self.tier ||= :standard
    self.isolation_model ||= :row
    self.settings ||= {}
  end
end
