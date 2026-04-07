module Portal
  class BookingsController < PortalBaseController
    before_action :set_booking, only: :show

    def index
      authorize Booking
      @bookings = policy_scope(Booking).includes(:product, :departure, :payments).order(created_at: :desc)
    end

    def show
      authorize @booking
      @travelers = @booking.travelers.order(:created_at)
      @payments = @booking.payments.order(paid_at: :desc)
      @support_cases = @booking.support_cases.includes(:assigned_user, :case_messages).order(created_at: :desc)
    end

    private

    def set_booking
      @booking = policy_scope(Booking).find(params[:id])
    end
  end
end
