require "test_helper"

class SupportFlowTest < ActionDispatch::IntegrationTest
  test "tenant support user can create a case and reply to it" do
    host! "demo.lvh.me"
    sign_in users(:demo_support)

    assert_difference("SupportCase.count", 1) do
      assert_difference("CaseMessage.count", 1) do
        post support_cases_path, params: {
          support_case: {
            booking_id: bookings(:demo_booking).id,
            subject: "Need updated invoice",
            contact_name: "Amina Rahman",
            contact_email: "amina@example.test",
            priority: "normal",
            assigned_user_id: users(:demo_support).id,
            initial_message: "Customer wants the latest invoice after deposit."
          }
        }
      end
    end

    support_case = SupportCase.order(:id).last
    assert_redirected_to support_case_path(support_case)

    assert_difference("CaseMessage.count", 1) do
      post support_case_case_messages_path(support_case), params: {
        case_message: {
          direction: "outbound",
          body: "Invoice regenerated and sent."
        }
      }
    end

    follow_redirect!
    assert_includes response.body, "Invoice regenerated and sent."
  end
end
