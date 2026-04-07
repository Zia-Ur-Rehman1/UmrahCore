# UmrahOps Pro

Rails-first multi-tenant Umrah and travel operations platform. This repo now implements the core MVP slices for:

1. Foundation bootstrap for a PostgreSQL-backed Rails monolith with Hotwire, Tailwind, Devise, Pundit, and CI.
2. Tenant-aware authentication and provisioning with host-based tenant resolution, a platform admin console, and a tenant workspace dashboard.
3. Catalog and departure management for tenant operators.
4. Booking intake, traveler management, payment capture, and ledger posting.
5. Support inbox workflows and a public tenant storefront.

## Stack

- Ruby 3.2.6
- Rails 7.0.10
- PostgreSQL 16 via Docker
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Devise
- Pundit
- Minitest

## Local setup

The repo is configured to talk to a local Docker Postgres container on `127.0.0.1:5432` with:

- database user: `postgres`
- database password: `postgres`

If you want different credentials, set:

- `DB_HOST`
- `DB_PORT`
- `DB_USER`
- `DB_PASSWORD`

Bootstrapping:

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

## Demo logins

Platform admin:

- email: `platform.admin@umrahopspro.test`
- password: `Password123!`

Demo tenant owner:

- email: `owner@demotravels.test`
- password: `Password123!`

Tenant-aware login URL:

```text
http://demo.lvh.me:3000/users/sign_in
```

Platform login URL:

```text
http://lvh.me:3000/users/sign_in
```

## Verification

Automated verification:

```bash
bin/rails test
bin/rails zeitwerk:check
bin/rails runner 'puts({tenants: Tenant.count, products: Product.count, departures: Departure.count}.inspect)'
bin/rails runner 'puts({bookings: Booking.count, payments: Payment.count, cases: SupportCase.count, case_messages: CaseMessage.count}.inspect)'
```

Smoke-check seeded data:

```bash
bin/rails runner 'puts({tenants: Tenant.count, users: User.count, demo_host: Tenant.find_by!(slug: "demo").primary_host}.inspect)'
```

Expected output shape:

```ruby
{:tenants=>1, :products=>1, :departures=>1}
```

```ruby
{:bookings=>2, :payments=>2, :cases=>2, :case_messages=>3}
```

## Current product slices

- [Feature chunks](./docs/architecture/feature_chunks.md)
- [Chunk 001 PR notes](./docs/pr/001-foundation-bootstrap.md)
- [Chunk 002 PR notes](./docs/pr/002-tenancy-auth-provisioning.md)
- [Chunk 003 PR notes](./docs/pr/003-catalog-and-departures.md)
- [Chunk 004 PR notes](./docs/pr/004-booking-operations.md)
- [Chunk 005 PR notes](./docs/pr/005-payments-ledger.md)
- [Chunk 006 PR notes](./docs/pr/006-support-and-storefront.md)
- [MVP rollup PR notes](./docs/pr/007-mvp-rollup.md)
- [TODO backlog](./TODO.md)
