# PR 002: Tenancy, Auth, and Provisioning

## Summary

This chunk turns the scaffold into a working multi-tenant control plane with platform-admin provisioning and tenant-aware dashboards.

## Included changes

- Added core tenancy models: `Tenant`, `DomainMapping`, and `User`.
- Added a request-time tenant resolver that supports:
  - `tenant.lvh.me` style subdomains
  - explicit domain mappings
  - `X-Tenant-Slug` override for testing and scripted requests
- Wired `Current` context so controllers and views can reliably reference the active tenant and user.
- Added a `Tenants::Provisioner` service that creates a tenant, primary host mapping, and initial owner in one transaction.
- Added a platform admin console for tenant creation.
- Added a tenant dashboard that confirms tenant resolution and displays tenant members and domains.
- Added seeded demo data for one platform admin and one demo tenant owner.

## Audit notes

- Tenant isolation is currently enforced at the resolver, controller, and policy layers. PostgreSQL RLS is explicitly deferred in `TODO.md`.
- Public self-registration is disabled. Users are created through provisioning or future invitation flows.
- The current onboarding flow accepts an initial owner password directly; invitation-driven setup remains a follow-up item.

## Verification

```bash
bin/rails db:seed
bin/rails test
bin/rails runner 'puts({tenants: Tenant.count, users: User.count, demo_host: Tenant.find_by!(slug: "demo").primary_host}.inspect)'
```

Manual smoke test:

1. Start the app with `bin/dev`.
2. Sign in at `http://lvh.me:3000/users/sign_in` as `platform.admin@umrahopspro.test`.
3. Create a tenant from `/platform/tenants/new`.
4. Sign in at `http://demo.lvh.me:3000/users/sign_in` as `owner@demotravels.test`.
5. Confirm the tenant workspace shows the demo domain mapping and member list.
