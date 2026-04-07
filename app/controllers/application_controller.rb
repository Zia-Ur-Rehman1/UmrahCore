class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :authentication_not_required?
  around_action :set_current_attributes

  helper_method :current_tenant

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  private

  def current_tenant
    Current.tenant
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
end
