module Platform
  class TenantsController < ApplicationController
    def index
      authorize Tenant
      @tenants = policy_scope(Tenant).includes(:primary_domain_mapping, :users).order(created_at: :desc)
    end

    def new
      authorize Tenant
      @tenant = Tenant.new(tier: :standard, isolation_model: :row)
    end

    def create
      authorize Tenant

      result = Tenants::Provisioner.call(
        tenant_attributes: tenant_attributes,
        owner_attributes: owner_attributes
      )

      if result.success?
        redirect_to platform_tenants_path, notice: "Tenant #{result.tenant.name} was provisioned with owner #{result.owner.email}."
      else
        @tenant = result.tenant
        flash.now[:alert] = result.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    private

    def tenant_attributes
      params.require(:tenant).permit(:name, :slug, :tier, :isolation_model, :support_email, :region)
    end

    def owner_attributes
      params.require(:tenant).permit(:owner_full_name, :owner_email, :owner_password).then do |attrs|
        {
          full_name: attrs[:owner_full_name],
          email: attrs[:owner_email],
          password: attrs[:owner_password],
          password_confirmation: attrs[:owner_password],
          role: :owner
        }
      end
    end
  end
end
