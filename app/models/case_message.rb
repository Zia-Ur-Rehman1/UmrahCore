class CaseMessage < ApplicationRecord
  include TenantOwned

  belongs_to :support_case
  belongs_to :user

  enum direction: {
    inbound: 0,
    outbound: 1,
    internal_note: 2
  }, _prefix: true

  before_validation :apply_defaults
  after_commit :update_case_timestamps, on: :create

  validates :body, :direction, presence: true

  private

  def apply_defaults
    self.direction ||= :outbound
    self.sent_at ||= Time.current
  end

  def update_case_timestamps
    attrs = {}
    attrs[:first_response_at] = sent_at if direction_outbound? && support_case.first_response_at.blank?
    attrs[:resolved_at] = Time.current if direction_internal_note? && body.to_s.downcase.include?("resolved")
    support_case.update_columns(attrs) if attrs.present?
  end
end
