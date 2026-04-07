class TravelersController < TenantBaseController
  before_action :set_booking

  def new
    authorize @booking, :update?
    @traveler = @booking.travelers.new
  end

  def create
    authorize @booking, :update?
    @traveler = @booking.travelers.new(traveler_params)
    @traveler.tenant = current_tenant

    if @traveler.save
      redirect_to @booking, notice: "Traveler #{@traveler.full_name} was added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = policy_scope(Booking).find(params[:booking_id])
  end

  def traveler_params
    params.require(:traveler).permit(:full_name, :passport_number, :date_of_birth, :status, :notes)
  end
end
