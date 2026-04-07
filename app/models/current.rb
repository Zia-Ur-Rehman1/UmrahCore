class Current < ActiveSupport::CurrentAttributes
  attribute :request_id, :tenant, :user
end
