class TenantBaseController < ApplicationController
  before_action :ensure_tenant_workspace!

  private

  def ensure_tenant_workspace!
    return if current_tenant.present? && current_user.workspace_access? && current_user.accessible_to_tenant?(current_tenant)

    redirect_to root_path, alert: "Tenant context is required. Use your tenant subdomain or custom domain."
  end
end
