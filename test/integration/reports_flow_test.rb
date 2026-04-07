require "test_helper"

class ReportsFlowTest < ActionDispatch::IntegrationTest
  test "finance user can view reports and export csv files" do
    host! "demo.lvh.me"
    sign_in users(:demo_finance)

    get reports_path, params: { from: "2026-04-01", to: "2026-04-30" }

    assert_response :success
    assert_includes response.body, "Exports and KPI snapshot"
    assert_includes response.body, bookings(:demo_booking).booking_ref
    assert_includes response.body, "USD 1,500.00"
    assert_includes response.body, "USD 5,850.00"

    get bookings_reports_path(format: :csv), params: { from: "2026-04-01", to: "2026-04-30" }

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.body, "booking_ref,lead_traveler_name"
    assert_includes response.body, bookings(:demo_booking).booking_ref

    get payments_reports_path(format: :csv), params: { from: "2026-04-01", to: "2026-04-30" }

    assert_response :success
    assert_includes response.body, payments(:deposit_payment).external_reference
  end
end
