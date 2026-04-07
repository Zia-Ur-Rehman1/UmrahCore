module SupportCases
  class Creator
    Result = Struct.new(:support_case, :errors, keyword_init: true) do
      def success?
        errors.blank?
      end
    end

    def self.call(tenant:, user:, attributes:)
      new(tenant:, user:, attributes:).call
    end

    def initialize(tenant:, user:, attributes:)
      @tenant = tenant
      @user = user
      @attributes = attributes.to_h.symbolize_keys
    end

    def call
      initial_message = attributes.delete(:initial_message)
      support_case = tenant.support_cases.new(attributes)
      support_case.assigned_user ||= user

      ActiveRecord::Base.transaction do
        support_case.save!
        if initial_message.present?
          support_case.case_messages.create!(
            tenant: tenant,
            user: user,
            body: initial_message,
            direction: :outbound
          )
        end
      end

      Result.new(support_case: support_case, errors: ActiveModel::Errors.new(self))
    rescue ActiveRecord::RecordInvalid
      Result.new(support_case: support_case, errors: support_case.errors)
    end

    private

    attr_reader :tenant, :user, :attributes
  end
end
