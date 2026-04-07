class HomeController < ApplicationController
  def show
    return redirect_to workspace_home_path_for(current_user) if user_signed_in? && (current_user.platform_admin? || current_tenant.present?)

    return unless current_tenant.present?

    @storefront_products = current_tenant.products.status_published.includes(:departures).order(:name)
    @upcoming_departures = current_tenant.departures.status_published.order(:departure_date).limit(6)
  end
end
