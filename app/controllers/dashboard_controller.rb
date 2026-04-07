class DashboardController < ApplicationController
  before_action :ensure_tenant_context!, unless: -> { current_user.platform_admin? }

  def show
    authorize :dashboard, :show?

    if current_tenant.present?
      @domain_mappings = current_tenant.domain_mappings.order(primary: :desc, created_at: :asc)
      @members = current_tenant.users.order(:full_name)
      @bookings_count = current_tenant.bookings.count
      @payments_received_cents = current_tenant.payments.where(status: :succeeded).sum(:amount_cents)
      @outstanding_cents = current_tenant.bookings.sum(:outstanding_cents)
      @open_cases_count = current_tenant.support_cases.where.not(status: :resolved).count
      @recent_bookings = current_tenant.bookings.includes(:product, :departure).order(created_at: :desc).limit(5)
      @recent_cases = current_tenant.support_cases.includes(:assigned_user).order(created_at: :desc).limit(5)
    else
      @tenants = policy_scope(Tenant).includes(:primary_domain_mapping, :users).order(created_at: :desc)
    end
  end

  private

  def ensure_tenant_context!
    return if current_tenant.present? && current_user.accessible_to_tenant?(current_tenant)

    redirect_to root_path, alert: "Tenant context is required. Use your tenant subdomain or custom domain."
  end
end
