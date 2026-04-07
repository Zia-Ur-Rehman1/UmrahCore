module Portal
  class DashboardController < PortalBaseController
    def show
      authorize :portal_dashboard, :show?

      bookings_scope = policy_scope(Booking)
      @bookings = bookings_scope.includes(:product, :departure, :payments, :support_cases).order(created_at: :desc)
      @bookings_count = bookings_scope.count
      @amount_paid_cents = bookings_scope.sum(:amount_paid_cents)
      @outstanding_cents = bookings_scope.sum(:outstanding_cents)
      @open_cases_count = current_tenant.support_cases.where(booking_id: bookings_scope.select(:id)).where.not(status: :resolved).count
      @next_departure = bookings_scope.joins(:departure).where("departures.departure_date >= ?", Date.current).order("departures.departure_date ASC").first
    end
  end
end
