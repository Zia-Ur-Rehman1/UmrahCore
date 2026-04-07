class DomainMapping < ApplicationRecord
  include TenantOwned

  enum kind: {
    subdomain: 0,
    custom_domain: 1
  }, _prefix: true

  before_validation :normalize_host
  before_validation :apply_defaults

  validates :host, presence: true, uniqueness: true
  validates :kind, presence: true
  validates :primary, inclusion: { in: [true, false] }
  validate :single_primary_mapping, if: :primary?

  private

  def normalize_host
    self.host = host.to_s.downcase.strip if host.present?
  end

  def apply_defaults
    self.kind ||= :subdomain
    self.primary = false if primary.nil?
  end

  def single_primary_mapping
    return if tenant.blank?

    existing_primary = tenant.domain_mappings.where(primary: true).where.not(id: id)
    errors.add(:primary, "has already been assigned for this tenant") if existing_primary.exists?
  end
end
