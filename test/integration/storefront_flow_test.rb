require "test_helper"

class StorefrontFlowTest < ActionDispatch::IntegrationTest
  test "tenant root host shows the public storefront for signed-out visitors" do
    host! "demo.lvh.me"

    get root_path

    assert_response :success
    assert_includes response.body, "Demo Travels storefront"
    assert_includes response.body, "Premium Spring Umrah"
    assert_includes response.body, "Upcoming departures"
  end
end
