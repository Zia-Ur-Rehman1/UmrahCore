class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :assigned_support_cases, class_name: "SupportCase", foreign_key: :assigned_user_id, dependent: :nullify, inverse_of: :assigned_user
  has_many :case_messages, dependent: :restrict_with_error

  belongs_to :tenant, optional: true

  enum status: {
    invited: 0,
    active: 1,
    suspended: 2
  }, _prefix: true

  enum role: {
    owner: 0,
    operations_manager: 1,
    sales_agent: 2,
    finance_officer: 3,
    support_agent: 4,
    group_leader: 5,
    customer: 6
  }, _prefix: true

  before_validation :normalize_email
  before_validation :apply_defaults

  validates :full_name, presence: true
  validates :status, presence: true
  validates :tenant, presence: true, unless: :platform_admin?
  validates :role, presence: true, unless: :platform_admin?

  def accessible_to_tenant?(candidate_tenant)
    platform_admin? || tenant == candidate_tenant
  end

  def tenant_admin?
    platform_admin? || role_owner?
  end

  def finance_access?
    tenant_admin? || role_finance_officer?
  end

  def support_access?
    tenant_admin? || role_support_agent?
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def apply_defaults
    self.platform_admin = false if platform_admin.nil?
    self.status ||= :active
    self.role ||= :owner unless platform_admin?
  end
end
