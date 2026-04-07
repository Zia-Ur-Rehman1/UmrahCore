class DeparturesController < TenantBaseController
  before_action :set_product

  def new
    authorize @product, :update?
    @departure = @product.departures.new
  end

  def create
    authorize @product, :update?
    @departure = @product.departures.new(departure_params)
    @departure.tenant = current_tenant

    if @departure.save
      redirect_to @product, notice: "Departure for #{@product.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:product_id])
  end

  def departure_params
    params.require(:departure).permit(
      :departure_date,
      :return_date,
      :capacity,
      :reserved_count,
      :confirmed_count,
      :fare_lock_deadline,
      :status,
      :notes
    )
  end
end
