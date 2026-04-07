module Tenancy
  class Resolver
    def self.call(request:)
      new(request: request).call
    end

    def initialize(request:)
      @request = request
    end

    def call
      tenant_from_header || tenant_from_subdomain || tenant_from_domain_mapping
    end

    private

    attr_reader :request

    def tenant_from_header
      slug = request.headers["X-Tenant-Slug"].to_s.parameterize
      return if slug.blank?

      Tenant.find_by(slug: slug)
    end

    def tenant_from_subdomain
      return if request.host.blank?
      return unless request.host.end_with?(".#{platform_domain}")

      slug = request.host.delete_suffix(".#{platform_domain}").split(".").first
      return if slug.blank?

      Tenant.find_by(slug: slug)
    end

    def tenant_from_domain_mapping
      DomainMapping.includes(:tenant).find_by(host: normalized_host)&.tenant
    end

    def normalized_host
      request.host.to_s.downcase
    end

    def platform_domain
      ENV.fetch("PLATFORM_DOMAIN", "lvh.me")
    end
  end
end
