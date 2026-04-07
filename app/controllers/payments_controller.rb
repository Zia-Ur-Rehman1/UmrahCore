class PaymentsController < TenantBaseController
  before_action :set_booking

  def new
    authorize @booking, :update?
    @payment = @booking.payments.new(currency: @booking.currency, payment_method: "manual_transfer")
  end

  def create
    authorize @booking, :update?
    result = Payments::Recorder.call(booking: @booking, attributes: payment_params, actor: current_user)
    @payment = result.payment

    if result.success?
      redirect_to @booking, notice: "Payment of #{helpers.currency_amount(@payment.amount_cents, @payment.currency)} was recorded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = policy_scope(Booking).find(params[:booking_id])
  end

  def payment_params
    params.require(:payment).permit(:amount_cents, :currency, :status, :payment_method, :external_reference, :paid_at, :notes)
  end
end
