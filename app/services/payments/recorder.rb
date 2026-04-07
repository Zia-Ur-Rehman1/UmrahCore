module Payments
  class Recorder
    Result = Struct.new(:payment, :booking, :errors, keyword_init: true) do
      def success?
        errors.blank?
      end
    end

    def self.call(booking:, attributes:, actor:)
      new(booking:, attributes:, actor:).call
    end

    def initialize(booking:, attributes:, actor:)
      @booking = booking
      @attributes = attributes.to_h.symbolize_keys
      @actor = actor
    end

    def call
      payment = booking.payments.new(attributes)
      payment.tenant = booking.tenant

      ActiveRecord::Base.transaction do
        payment.save!
        booking.amount_paid_cents += payment.amount_cents
        booking.recalculate_payment_state!
        booking.save!
        booking.ledger_entries.create!(
          tenant: booking.tenant,
          payment: payment,
          entry_type: :payment_receipt,
          debit_account: "Cash",
          credit_account: "Deferred Revenue",
          amount_cents: payment.amount_cents,
          currency: payment.currency,
          posted_at: payment.paid_at,
          description: "Payment recorded by #{actor.full_name} for #{booking.booking_ref}",
          idempotency_key: "payment-#{payment.id}"
        )
      end

      Result.new(payment: payment, booking: booking, errors: ActiveModel::Errors.new(self))
    rescue ActiveRecord::RecordInvalid
      Result.new(payment: payment, booking: booking, errors: payment.errors.presence || booking.errors)
    end

    private

    attr_reader :booking, :attributes, :actor
  end
end
