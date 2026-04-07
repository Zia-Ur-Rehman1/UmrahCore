require "test_helper"

class BookingTest < ActiveSupport::TestCase
  test "portal users must match supported roles" do
    booking = bookings(:demo_booking).dup
    booking.booking_ref = "DEM-260407-ZZ"
    booking.idempotency_key = "fixture-booking-validation"
    booking.customer_user = users(:demo_support)

    assert_not booking.valid?
    assert_includes booking.errors[:customer_user], "must have the customer role"
  end

  test "portal visibility matches assigned customer or group leader" do
    booking = bookings(:demo_booking)

    assert booking.visible_to_portal_user?(users(:demo_customer))
    assert booking.visible_to_portal_user?(users(:demo_group_leader))
    assert_not booking.visible_to_portal_user?(users(:demo_support))
  end
end
