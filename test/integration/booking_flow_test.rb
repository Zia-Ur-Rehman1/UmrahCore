require "test_helper"

class BookingFlowTest < ActionDispatch::IntegrationTest
  test "tenant owner can create a booking and add a traveler" do
    host! "demo.lvh.me"
    sign_in users(:demo_owner)

    assert_difference("Booking.count", 1) do
      post bookings_path, params: {
        booking: {
          product_id: products(:demo_package).id,
          departure_id: departures(:demo_november).id,
          lead_traveler_name: "Ibrahim Khan",
          lead_traveler_email: "ibrahim@example.test",
          travelers_count: 3,
          payment_plan: "Installment",
          notes: "Family booking"
        }
      }
    end

    booking = Booking.order(:id).last
    assert_redirected_to booking_path(booking)
    follow_redirect!
    assert_includes response.body, booking.booking_ref
    assert_includes response.body, "Ibrahim Khan"

    assert_difference("Traveler.count", 1) do
      post booking_travelers_path(booking), params: {
        traveler: {
          full_name: "Fatima Khan",
          passport_number: "PK8888888",
          status: "verified"
        }
      }
    end

    follow_redirect!
    assert_includes response.body, "Fatima Khan"
  end
end
