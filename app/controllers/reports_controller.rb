require "csv"

class ReportsController < TenantBaseController
  before_action :set_reporting_window

  def index
    authorize :report, :index?

    base_bookings_scope = bookings_scope
    base_payments_scope = payments_scope
    base_support_cases_scope = support_cases_scope

    @bookings = base_bookings_scope.includes(:product, :departure, :customer_user, :group_leader_user).order(created_at: :desc)
    @payments = base_payments_scope.includes(:booking).order(paid_at: :desc)
    @support_cases = base_support_cases_scope.includes(:booking, :assigned_user).order(created_at: :desc)

    @bookings_count = base_bookings_scope.count
    @gross_booking_value_cents = base_bookings_scope.sum(:total_price_cents)
    @payments_received_cents = base_payments_scope.where(status: :succeeded).sum(:amount_cents)
    @outstanding_cents = base_bookings_scope.sum(:outstanding_cents)
    @open_cases_count = base_support_cases_scope.where.not(status: :resolved).count
  end

  def bookings
    authorize :report, :index?

    send_data(
      CSV.generate(headers: true) do |csv|
        csv << ["booking_ref", "lead_traveler_name", "lead_traveler_email", "customer", "group_leader", "product", "departure_date", "status", "total_price_cents", "amount_paid_cents", "outstanding_cents", "created_at"]
        bookings_scope.includes(:product, :departure, :customer_user, :group_leader_user).order(created_at: :desc).find_each do |booking|
          csv << [
            booking.booking_ref,
            booking.lead_traveler_name,
            booking.lead_traveler_email,
            booking.customer_user&.full_name,
            booking.group_leader_user&.full_name,
            booking.product.name,
            booking.departure.departure_date,
            booking.status,
            booking.total_price_cents,
            booking.amount_paid_cents,
            booking.outstanding_cents,
            booking.created_at.iso8601
          ]
        end
      end,
      filename: "bookings-#{@from_date}-to-#{@to_date}.csv",
      type: "text/csv"
    )
  end

  def payments
    authorize :report, :index?

    send_data(
      CSV.generate(headers: true) do |csv|
        csv << ["external_reference", "booking_ref", "amount_cents", "currency", "status", "payment_method", "paid_at", "created_at"]
        payments_scope.includes(:booking).order(paid_at: :desc).find_each do |payment|
          csv << [
            payment.external_reference,
            payment.booking.booking_ref,
            payment.amount_cents,
            payment.currency,
            payment.status,
            payment.payment_method,
            payment.paid_at&.iso8601,
            payment.created_at.iso8601
          ]
        end
      end,
      filename: "payments-#{@from_date}-to-#{@to_date}.csv",
      type: "text/csv"
    )
  end

  def support_cases
    authorize :report, :index?

    send_data(
      CSV.generate(headers: true) do |csv|
        csv << ["case_ref", "booking_ref", "subject", "contact_name", "priority", "status", "assigned_user", "source", "created_at"]
        support_cases_scope.includes(:booking, :assigned_user).order(created_at: :desc).find_each do |support_case|
          csv << [
            support_case.case_ref,
            support_case.booking&.booking_ref,
            support_case.subject,
            support_case.contact_name,
            support_case.priority,
            support_case.status,
            support_case.assigned_user&.full_name,
            support_case.source,
            support_case.created_at.iso8601
          ]
        end
      end,
      filename: "support-cases-#{@from_date}-to-#{@to_date}.csv",
      type: "text/csv"
    )
  end

  private

  def set_reporting_window
    @to_date = parse_date(params[:to]) || Date.current
    @from_date = parse_date(params[:from]) || (@to_date - 30.days)
  end

  def parse_date(value)
    return if value.blank?

    Date.parse(value)
  rescue ArgumentError
    nil
  end

  def bookings_scope
    current_tenant.bookings.where(created_at: @from_date.beginning_of_day..@to_date.end_of_day)
  end

  def payments_scope
    current_tenant.payments.where("COALESCE(payments.paid_at, payments.created_at) BETWEEN ? AND ?", @from_date.beginning_of_day, @to_date.end_of_day)
  end

  def support_cases_scope
    current_tenant.support_cases.where(created_at: @from_date.beginning_of_day..@to_date.end_of_day)
  end
end
