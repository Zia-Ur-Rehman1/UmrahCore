require "test_helper"

module Tenants
  class ProvisionerTest < ActiveSupport::TestCase
    test "creates tenant owner and primary host together" do
      result = Provisioner.call(
        tenant_attributes: {
          name: "Atlas Umrah",
          slug: "atlas-umrah",
          tier: :standard,
          isolation_model: :row,
          support_email: "support@atlas.test",
          region: "AE"
        },
        owner_attributes: {
          full_name: "Atlas Owner",
          email: "owner@atlas.test",
          password: "Password123!",
          password_confirmation: "Password123!",
          role: :owner
        }
      )

      assert result.success?
      assert_equal "atlas-umrah.lvh.me", result.tenant.primary_host
      assert_equal result.tenant, result.owner.tenant
      assert result.owner.role_owner?
    end
  end
end
