require "test_helper"

class FinanceFlowTest < ActionDispatch::IntegrationTest
  test "tenant finance user can record payment and create ledger entry" do
    host! "demo.lvh.me"
    sign_in users(:demo_finance)
    booking = bookings(:demo_booking)

    assert_difference("Payment.count", 1) do
      assert_difference("LedgerEntry.count", 1) do
        post booking_payments_path(booking), params: {
          payment: {
            amount_cents: 340000,
            currency: "USD",
            status: "succeeded",
            payment_method: "stripe",
            external_reference: "PAY-FULL-001",
            paid_at: "2026-04-07T12:00",
            notes: "Final payment"
          }
        }
      end
    end

    assert_redirected_to booking_path(booking)
    booking.reload
    assert booking.status_confirmed?
    assert_equal 0, booking.outstanding_cents
  end
end
