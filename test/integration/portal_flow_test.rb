require "test_helper"

class PortalFlowTest < ActionDispatch::IntegrationTest
  test "customer sees only assigned bookings in the client portal" do
    host! "demo.lvh.me"
    sign_in users(:demo_customer)

    get root_path
    assert_redirected_to portal_dashboard_path

    follow_redirect!
    assert_response :success
    assert_includes response.body, "Client Portal"
    assert_includes response.body, bookings(:demo_booking).booking_ref
    assert_includes response.body, "USD 1,500.00"
    assert_includes response.body, "USD 3,400.00"
    assert_not_includes response.body, bookings(:demo_internal_booking).booking_ref

    get portal_booking_path(bookings(:demo_booking))

    assert_response :success
    assert_includes response.body, "Need rooming confirmation"
    assert_includes response.body, "Manual transfer"
  end

  test "portal users are blocked from operator-only screens" do
    host! "demo.lvh.me"
    sign_in users(:demo_customer)

    get dashboard_path

    assert_redirected_to root_path

    get reports_path

    assert_redirected_to root_path
  end
end
