module TenantOwned
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant

    before_validation :assign_current_tenant, on: :create

    scope :for_current_tenant, -> { where(tenant: Current.tenant) }
  end

  private

  def assign_current_tenant
    self.tenant ||= Current.tenant if Current.tenant.present?
  end
end
