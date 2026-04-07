# TODO

## Blockers and deferred work

- Upgrade the scaffold from Rails `7.0.10` to Rails `8.x` once the local toolchain is available. The current environment only had Rails 7 preinstalled, so the build started on the closest stable base instead of stalling.
- Add PostgreSQL row-level security policies for tenant-owned tables. The current slice enforces tenancy at the request, service, and policy layers but does not yet add database RLS.
- Replace direct owner password entry with invitation flows and reset/setup tokens. The specification calls for invitation-driven onboarding and stronger auth controls.
- Add MFA, lockable/throttling, and sensitive-role session hardening for `platform_admin`, `owner`, and `finance_officer`.
- Wire `Solid Queue` as the default Active Job backend after the Rails upgrade path is settled. The current slice uses the Rails job interface but does not yet configure queue infrastructure.
- Add AnyCable and Turbo Stream broadcasts for live dashboard and inbox updates.
- Define the full role/permission matrix beyond the initial `owner` and platform-admin paths.
- Add custom-domain verification and DNS ownership workflow instead of simple host record creation.
- Seed default queues, chart of accounts, branding config, payment config placeholders, and audit logs during tenant provisioning.
- Decide the exact WhatsApp provider abstraction and webhook signature rules for Phase 1 messaging work.
- Add document upload and Active Storage workflows for traveler passport files and receipts.
- Add real Stripe checkout, webhook idempotency, refunds, and payout reconciliation instead of the current manual finance capture flow.
- Add self-service customer/client portal authentication and booking visibility.
- Add reporting exports and scheduled metric snapshots beyond the current dashboard aggregates.

## Next execution chunks

- Client portal and self-service booking visibility
- Reporting exports and KPI snapshots
- Stripe webhooks and reconciliation
- Document management
- Real-time inbox/dashboard updates
