# PR 008: Client Portal and Reporting

## Summary

This chunk extends the tenant storefront into a working client portal and adds operator-grade reporting exports without blocking on Stripe, AnyCable, or document infrastructure.

## Included changes

- Added dedicated client portal surfaces for `customer` and `group_leader` users.
- Added booking ownership fields for portal users and automatic lead-email assignment during booking creation.
- Split workspace authorization from portal authorization so customers do not inherit operator access.
- Added a tenant reporting page with KPI cards for bookings, payments, outstanding balances, and open cases.
- Added CSV exports for bookings, payments, and support cases across a selected reporting window.
- Seeded demo portal users and linked the seeded booking to them.
- Added integration coverage for:
  - portal booking visibility
  - operator-only screen blocking for portal users
  - reporting page access
  - CSV export responses

## Audit notes

- Portal users currently have read-only visibility into assigned bookings, linked support cases, and payment status. Self-service payment actions and document uploads remain deferred.
- Reporting is currently on-demand and query-backed. Scheduled snapshots and async export delivery remain follow-up work.

## Verification

```bash
bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test
bin/rails test test/integration/portal_flow_test.rb test/integration/reports_flow_test.rb
bin/rails test test/models/booking_test.rb test/models/user_test.rb
```
