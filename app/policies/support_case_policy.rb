class SupportCasePolicy < ApplicationPolicy
  def index?
    support_operator? || tenant_operator?
  end

  def show?
    (support_operator? || tenant_operator?) && within_current_tenant?
  end

  def new?
    create?
  end

  def create?
    tenant_operator?
  end

  def update?
    support_operator? || tenant_operator?
  end

  class Scope < Scope
    def resolve
      tenant_scope
    end
  end
end
