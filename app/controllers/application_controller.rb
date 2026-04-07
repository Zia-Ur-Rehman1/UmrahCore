class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :authentication_not_required?
  around_action :set_current_attributes

  helper_method :current_tenant, :workspace_home_path_for

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  private

  def current_tenant
    Current.tenant
  end

  def workspace_home_path_for(user)
    return dashboard_path if user.platform_admin?
    return portal_dashboard_path if current_tenant.present? && user.portal_access?
    return dashboard_path if current_tenant.present? && user.workspace_access?

    root_path
  end

  def authentication_not_required?
    devise_controller? || is_a?(HomeController)
  end

  def set_current_attributes
    Current.set(
      request_id: request.uuid,
      user: current_user,
      tenant: Tenancy::Resolver.call(request: request)
    ) do
      yield
    end
  ensure
    Current.reset
  end

  def handle_not_authorized
    redirect_to root_path, alert: "You are not authorized to access that area."
  end

  def after_sign_in_path_for(resource)
    workspace_home_path_for(resource)
  end
end
