class DashboardPolicy < ApplicationPolicy
  def show?
    return false unless user
    return true if user.platform_admin?

    Current.tenant.present? && user.workspace_access? && user.accessible_to_tenant?(Current.tenant)
  end
end
