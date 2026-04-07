class ReportPolicy < ApplicationPolicy
  def index?
    reporting_operator?
  end
end
