module Tenants
  class Provisioner
    Result = Struct.new(:tenant, :owner, :errors, keyword_init: true) do
      def success?
        errors.blank?
      end
    end

    def self.call(tenant_attributes:, owner_attributes:)
      new(tenant_attributes:, owner_attributes:).call
    end

    def initialize(tenant_attributes:, owner_attributes:)
      @tenant_attributes = tenant_attributes.to_h.symbolize_keys
      @owner_attributes = owner_attributes.to_h.symbolize_keys
    end

    def call
      tenant = Tenant.new(@tenant_attributes)
      owner = tenant.users.build(@owner_attributes.merge(status: :active))

      ActiveRecord::Base.transaction do
        tenant.save!
        tenant.domain_mappings.create!(
          host: "#{tenant.slug}.#{platform_domain}",
          kind: :subdomain,
          primary: true,
          verified_at: Time.current
        )
        owner.save!
      end

      Result.new(tenant: tenant, owner: owner, errors: ActiveModel::Errors.new(self))
    rescue ActiveRecord::RecordInvalid
      Result.new(tenant: tenant, owner: owner, errors: merge_errors(tenant, owner))
    end

    private

    def merge_errors(*records)
      errors = ActiveModel::Errors.new(self)
      records.compact.each do |record|
        record.errors.each do |error|
          errors.add(error.attribute, error.message)
        end
      end
      errors
    end

    def platform_domain
      ENV.fetch("PLATFORM_DOMAIN", "lvh.me")
    end
  end
end
