class TenantPolicy < ApplicationPolicy
  def index?
    user&.platform_admin?
  end

  def new?
    create?
  end

  def create?
    user&.platform_admin?
  end

  class Scope < Scope
    def resolve
      user&.platform_admin? ? scope.all : scope.none
    end
  end
end
