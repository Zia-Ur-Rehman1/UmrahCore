require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "workspace and portal access are separated by role" do
    assert users(:demo_owner).workspace_access?
    assert_not users(:demo_owner).portal_access?

    assert users(:demo_customer).portal_access?
    assert_not users(:demo_customer).workspace_access?
  end

  test "reporting access is limited to internal reporting roles" do
    assert users(:demo_finance).reporting_access?
    assert users(:demo_owner).reporting_access?
    assert_not users(:demo_customer).reporting_access?
  end
end
