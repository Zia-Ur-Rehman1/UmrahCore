class BookingPolicy < ApplicationPolicy
  def index?
    tenant_operator? || portal_user?
  end

  def show?
    return tenant_operator? && within_current_tenant? if tenant_operator?

    portal_user? && within_current_tenant? && record.visible_to_portal_user?(user)
  end

  def new?
    create?
  end

  def create?
    tenant_operator?
  end

  def update?
    tenant_operator? && within_current_tenant?
  end

  class Scope < Scope
    def resolve
      return tenant_scope if user&.workspace_access?
      return portal_scope.for_portal_user(user) if user&.portal_access?

      scope.none
    end
  end
end
