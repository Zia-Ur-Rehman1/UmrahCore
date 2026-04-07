class BookingsController < TenantBaseController
  before_action :set_booking, only: :show

  def index
    authorize Booking
    @bookings = policy_scope(Booking).includes(:product, :departure, :payments).order(created_at: :desc)
  end

  def show
    authorize @booking
    @travelers = @booking.travelers.order(:created_at)
    @payments = @booking.payments.order(paid_at: :desc)
    @ledger_entries = @booking.ledger_entries.order(posted_at: :desc)
    @support_cases = @booking.support_cases.order(created_at: :desc)
  end

  def new
    authorize Booking
    @booking = current_tenant.bookings.new(travelers_count: 1)
    @products = current_tenant.products.order(:name)
  end

  def create
    authorize Booking
    result = Bookings::Creator.call(tenant: current_tenant, attributes: booking_params)
    @booking = result.booking
    @products = current_tenant.products.order(:name)

    if result.success?
      redirect_to @booking, notice: "Booking #{@booking.booking_ref} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = policy_scope(Booking).find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :product_id,
      :departure_id,
      :lead_traveler_name,
      :lead_traveler_email,
      :travelers_count,
      :payment_plan,
      :notes
    )
  end
end
