class SupportCase < ApplicationRecord
  include TenantOwned

  belongs_to :assigned_user, class_name: "User", optional: true, inverse_of: :assigned_support_cases
  belongs_to :booking, optional: true

  has_many :case_messages, dependent: :destroy

  enum priority: {
    low: 0,
    normal: 1,
    high: 2,
    urgent: 3
  }, _prefix: true

  enum status: {
    open: 0,
    pending_customer: 1,
    pending_internal: 2,
    resolved: 3
  }, _prefix: true

  before_validation :apply_defaults
  before_validation :normalize_email
  before_validation :generate_case_ref, on: :create

  validates :case_ref, :subject, :contact_name, :priority, :status, :source, presence: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  private

  def apply_defaults
    self.priority ||= :normal
    self.status ||= :open
    self.source ||= "web"
    self.sla_due_at ||= 24.hours.from_now
  end

  def normalize_email
    self.contact_email = contact_email.to_s.downcase.strip if contact_email.present?
  end

  def generate_case_ref
    self.case_ref ||= "CASE-#{Time.current.strftime('%y%m%d')}-#{SecureRandom.hex(2).upcase}"
  end
end
