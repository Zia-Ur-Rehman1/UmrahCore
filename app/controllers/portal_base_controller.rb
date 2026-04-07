class PortalBaseController < ApplicationController
  before_action :ensure_portal_workspace!

  private

  def ensure_portal_workspace!
    return if current_tenant.present? && current_user.portal_access? && current_user.accessible_to_tenant?(current_tenant)

    redirect_to root_path, alert: "Client portal access requires your agency host and a portal user account."
  end
end
