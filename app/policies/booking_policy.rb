class BookingPolicy < ApplicationPolicy
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
    tenant_operator?
  end

  def update?
    tenant_operator? && within_current_tenant?
  end

  class Scope < Scope
    def resolve
      tenant_scope
    end
  end
end
