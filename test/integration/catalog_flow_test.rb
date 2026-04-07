require "test_helper"

class CatalogFlowTest < ActionDispatch::IntegrationTest
  test "tenant owner can browse their catalog and create a product" do
    host! "demo.lvh.me"
    sign_in users(:demo_owner)

    get products_path

    assert_response :success
    assert_includes response.body, "Premium Spring Umrah"
    assert_not_includes response.body, "Second Horizon Escape"

    assert_difference("Product.count", 1) do
      post products_path, params: {
        product: {
          name: "Winter Umrah Saver",
          description: "Budget-friendly seasonal package",
          product_type: "umrah_package",
          base_price_cents: 185000,
          currency: "usd",
          duration_nights: 8,
          inclusions: "Visa support and transfers",
          status: "draft",
          b2c_enabled: "0"
        }
      }
    end

    assert_redirected_to product_path(Product.order(:id).last)
    follow_redirect!
    assert_includes response.body, "Winter Umrah Saver"
    assert_includes response.body, "USD 185000"
  end

  test "tenant owner can add a departure to their product" do
    host! "demo.lvh.me"
    sign_in users(:demo_owner)
    product = products(:demo_package)

    assert_difference("Departure.count", 1) do
      post product_departures_path(product), params: {
        departure: {
          departure_date: "2026-12-01",
          return_date: "2026-12-11",
          capacity: 30,
          reserved_count: 3,
          confirmed_count: 2,
          fare_lock_deadline: "2026-11-01T12:00",
          status: "published",
          notes: "December allocation"
        }
      }
    end

    assert_redirected_to product_path(product)
    follow_redirect!
    assert_includes response.body, "2026-12-01"
    assert_includes response.body, "December allocation"
  end
end
