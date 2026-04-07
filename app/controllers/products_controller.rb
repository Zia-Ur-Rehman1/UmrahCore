class ProductsController < TenantBaseController
  before_action :set_product, only: :show

  def index
    authorize Product
    @products = policy_scope(Product).includes(:departures).order(created_at: :desc)
  end

  def show
    authorize @product
    @departures = @product.departures.order(:departure_date)
  end

  def new
    authorize Product
    @product = current_tenant.products.new(currency: "USD")
  end

  def create
    authorize Product
    @product = current_tenant.products.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product #{@product.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :product_type,
      :base_price_cents,
      :currency,
      :duration_nights,
      :inclusions,
      :status,
      :b2c_enabled
    )
  end
end
