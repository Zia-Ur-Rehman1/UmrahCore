class PortalDashboardPolicy < ApplicationPolicy
  def show?
    portal_user?
  end
end
