class SupportCasesController < TenantBaseController
  before_action :set_support_case, only: :show

  def index
    authorize SupportCase
    @support_cases = policy_scope(SupportCase).includes(:booking, :assigned_user).order(created_at: :desc)
  end

  def show
    authorize @support_case
    @case_messages = @support_case.case_messages.includes(:user).order(:created_at)
    @case_message = @support_case.case_messages.new(direction: :outbound)
  end

  def new
    authorize SupportCase
    @support_case = current_tenant.support_cases.new
    @bookings = current_tenant.bookings.order(created_at: :desc)
    @assignees = current_tenant.users.order(:full_name)
  end

  def create
    authorize SupportCase
    result = SupportCases::Creator.call(tenant: current_tenant, user: current_user, attributes: support_case_params)
    @support_case = result.support_case
    @bookings = current_tenant.bookings.order(created_at: :desc)
    @assignees = current_tenant.users.order(:full_name)

    if result.success?
      redirect_to @support_case, notice: "Case #{@support_case.case_ref} was opened."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_support_case
    @support_case = policy_scope(SupportCase).find(params[:id])
  end

  def support_case_params
    params.require(:support_case).permit(
      :booking_id,
      :subject,
      :contact_name,
      :contact_email,
      :priority,
      :status,
      :source,
      :assigned_user_id,
      :initial_message
    )
  end
end
