# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def tenant_operator?
    user.present? && Current.tenant.present? && user.workspace_access? && user.accessible_to_tenant?(Current.tenant)
  end

  def tenant_admin?
    tenant_operator? && user.tenant_admin?
  end

  def finance_operator?
    tenant_operator? && user.finance_access?
  end

  def support_operator?
    tenant_operator? && user.support_access?
  end

  def reporting_operator?
    tenant_operator? && user.reporting_access?
  end

  def portal_user?
    user.present? && Current.tenant.present? && user.portal_access? && user.accessible_to_tenant?(Current.tenant)
  end

  def within_current_tenant?
    record.respond_to?(:tenant) && record.tenant == Current.tenant
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope

    def tenant_scope
      return scope.none unless user && Current.tenant.present?
      return scope.where(tenant: Current.tenant) if user.accessible_to_tenant?(Current.tenant)

      scope.none
    end

    def portal_scope
      return scope.none unless user && Current.tenant.present? && user.portal_access? && user.accessible_to_tenant?(Current.tenant)

      scope.where(tenant: Current.tenant)
    end
  end
end
