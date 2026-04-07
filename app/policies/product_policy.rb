class ProductPolicy < ApplicationPolicy
  def index?
    tenant_operator?
  end

  def show?
    tenant_operator? && within_current_tenant?
  end

  def new?
    create?
  end

  def create?
    tenant_admin?
  end

  def update?
    tenant_admin? && within_current_tenant?
  end

  class Scope < Scope
    def resolve
      tenant_scope
    end
  end
end
