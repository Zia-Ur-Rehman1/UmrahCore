module Bookings
  class Creator
    Result = Struct.new(:booking, :errors, keyword_init: true) do
      def success?
        errors.blank?
      end
    end

    def self.call(tenant:, attributes:)
      new(tenant:, attributes:).call
    end

    def initialize(tenant:, attributes:)
      @tenant = tenant
      @attributes = attributes.to_h.symbolize_keys
    end

    def call
      booking = tenant.bookings.new(attributes.except(:create_lead_traveler))
      assign_portal_contact!(booking)
      booking.total_price_cents = booking.product&.base_price_cents.to_i * booking.travelers_count.to_i
      booking.outstanding_cents = booking.total_price_cents
      booking.status = :pending_payment

      ActiveRecord::Base.transaction do
        booking.save!
        if ActiveModel::Type::Boolean.new.cast(attributes.fetch(:create_lead_traveler, true))
          booking.travelers.create!(
            tenant: tenant,
            full_name: booking.lead_traveler_name,
            status: :draft
          )
        end
      end

      Result.new(booking: booking, errors: ActiveModel::Errors.new(self))
    rescue ActiveRecord::RecordInvalid
      Result.new(booking: booking, errors: booking.errors)
    end

    private

    attr_reader :tenant, :attributes

    def assign_portal_contact!(booking)
      portal_user = tenant.users.find_by(email: booking.lead_traveler_email)
      return if portal_user.blank?

      booking.customer_user ||= portal_user if portal_user.role_customer?
      booking.group_leader_user ||= portal_user if portal_user.role_group_leader?
    end
  end
end
