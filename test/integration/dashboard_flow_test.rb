require "test_helper"

class DashboardFlowTest < ActionDispatch::IntegrationTest
  test "platform admin sees the platform console on the root domain" do
    host! "lvh.me"
    sign_in users(:platform_admin)

    get dashboard_path

    assert_response :success
    assert_includes response.body, "Tenant provisioning control plane"
    assert_includes response.body, "Demo Travels"
  end

  test "tenant owner sees only their workspace when host resolves" do
    host! "demo.lvh.me"
    sign_in users(:demo_owner)

    get dashboard_path

    assert_response :success
    assert_includes response.body, "Demo Travels"
    assert_includes response.body, "owner@demotravels.test"
    assert_not_includes response.body, "Second Horizon"
  end

  test "tenant owner is blocked when tenant context is missing" do
    host! "lvh.me"
    sign_in users(:demo_owner)

    get dashboard_path

    assert_redirected_to root_path
    follow_redirect!
    assert_includes response.body, "Tenant context is required"
  end
end
