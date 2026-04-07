class CaseMessagesController < TenantBaseController
  before_action :set_support_case

  def create
    authorize @support_case, :update?
    @case_message = @support_case.case_messages.new(case_message_params)
    @case_message.tenant = current_tenant
    @case_message.user = current_user

    if @case_message.save
      redirect_to @support_case, notice: "Case message sent."
    else
      @case_messages = @support_case.case_messages.includes(:user).order(:created_at)
      render "support_cases/show", status: :unprocessable_entity
    end
  end

  private

  def set_support_case
    @support_case = policy_scope(SupportCase).find(params[:support_case_id])
  end

  def case_message_params
    params.require(:case_message).permit(:body, :direction)
  end
end
