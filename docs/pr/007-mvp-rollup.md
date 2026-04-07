# PR 007: MVP Rollup

## Summary

This PR publishes the first reviewable MVP of UmrahOps Pro as a Rails monolith with tenant provisioning, tenant-aware operations, catalog and departures, bookings and travelers, payment capture with ledger posting, support cases and replies, dashboard aggregates, and a public tenant storefront.

## Why this changed

The repository started at the specification stage with no executable application. This PR moves it to a runnable and live-tested implementation that supports the core operator walkthrough end to end.

## Included changes

- Rails application scaffold with PostgreSQL, Hotwire, Tailwind, Devise, Pundit, and CI.
- Host-based tenancy resolution with platform-admin tenant provisioning.
- Tenant-scoped catalog and departure management.
- Booking creation and traveler management.
- Manual payment capture with booking balance updates and ledger entries.
- Support case creation and threaded replies.
- Public storefront rendering for tenant hosts.
- Client portal booking visibility for customer and group leader users.
- Reporting dashboards with CSV exports for bookings, payments, and support cases.
- Seeded demo users and data for a complete walkthrough.
- Chunk-level audit notes under `docs/pr/001` through `docs/pr/006`.

## Verified

Automated:

```bash
bin/rails test
bin/rails zeitwerk:check
bin/rails db:seed
bin/rails runner 'puts({bookings: Booking.count, payments: Payment.count, cases: SupportCase.count, case_messages: CaseMessage.count}.inspect)'
```

Live walkthrough on `http://demo.lvh.me:3000/`:

- Rendered the signed-out storefront.
- Signed in as `owner@demotravels.test`.
- Created booking `DEM-260407-ACAC`.
- Recorded a payment and confirmed booking status and balance updates.
- Opened support case `CASE-260407-A4B3`.
- Signed in as `support@demotravels.test` and posted a reply.
- Checked browser console output and confirmed zero console errors during the walkthrough.

## Pending

- Rails 8 upgrade once the local toolchain is available.
- PostgreSQL row-level security for tenant-owned tables.
- Invitation-driven onboarding, MFA, and stronger auth hardening.
- Real Stripe checkout, webhooks, refunds, and reconciliation.
- Traveler document uploads and Active Storage workflows.
- Client portal authentication and self-service booking visibility.
- Real-time AnyCable or Turbo broadcast updates.
- Portal self-service payment and document actions.
- Scheduled metric snapshots and async export delivery.
