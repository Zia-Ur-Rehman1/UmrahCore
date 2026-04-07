require "test_helper"

module Tenancy
  class ResolverTest < ActiveSupport::TestCase
    test "resolves tenants from lvh subdomains" do
      request = ActionDispatch::TestRequest.create("HTTP_HOST" => "demo.lvh.me")

      assert_equal tenants(:demo), Resolver.call(request: request)
    end

    test "resolves tenants from explicit host mappings" do
      request = ActionDispatch::TestRequest.create("HTTP_HOST" => "second.test")

      assert_equal tenants(:second), Resolver.call(request: request)
    end

    test "prefers explicit header override" do
      request = ActionDispatch::TestRequest.create("HTTP_HOST" => "unknown.test")
      request.headers["X-Tenant-Slug"] = "demo"

      assert_equal tenants(:demo), Resolver.call(request: request)
    end
  end
end
