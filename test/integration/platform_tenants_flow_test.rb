require "test_helper"

class PlatformTenantsFlowTest < ActionDispatch::IntegrationTest
  test "platform admin can provision a tenant from the web flow" do
    host! "lvh.me"
    sign_in users(:platform_admin)

    assert_difference("Tenant.count", 1) do
      assert_difference("User.count", 1) do
        post platform_tenants_path, params: {
          tenant: {
            name: "Hajj Connect",
            slug: "hajj-connect",
            tier: "premium",
            isolation_model: "schema",
            support_email: "support@hajjconnect.test",
            region: "SA",
            owner_full_name: "Hajj Owner",
            owner_email: "owner@hajjconnect.test",
            owner_password: "Password123!"
          }
        }
      end
    end

    assert_redirected_to platform_tenants_path
    follow_redirect!
    assert_includes response.body, "Hajj Connect"
    assert_includes response.body, "hajj-connect.lvh.me"
  end
end
