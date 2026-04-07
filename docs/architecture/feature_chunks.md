# Feature Chunks

Incremental roadmap extracted from `umrahops_pro_rails_master_spec.md` and converted into independently shippable slices.

## Chunk 001: Monolith foundation

Status: complete

- Rails monolith scaffold with PostgreSQL, Hotwire, Tailwind, Devise, and Pundit
- Docker-friendly database config
- CI workflow for database prep and test execution
- README and verification commands

## Chunk 002: Tenancy, auth, and provisioning

Status: complete

- `Tenant`, `DomainMapping`, and `User` core models
- Host-based tenant resolution through subdomain or explicit domain mapping
- Platform admin dashboard and tenant provisioning flow
- Tenant workspace dashboard with membership and domain visibility
- Seeded demo data and integration/service tests

## Chunk 003: Catalog and departure management

Status: complete

- `Product` and `Departure` core models
- Tenant admin UI for catalog creation and publication state
- Departure scheduling and capacity tracking

## Chunk 004: Booking intake and traveler operations

Status: complete

- `Booking`, `BookingItem`, `TravelerAssignment`, and `Document`
- Draft to confirmed booking lifecycle
- Soft holds, traveler forms, and document upload

## Chunk 005: Payments, ledger, and reconciliation

Status: complete

- Stripe checkout handoff and webhook ingestion
- `Payment`, `Refund`, `LedgerEntry`, and idempotent posting services
- Finance dashboard and exception capture

## Chunk 006: Support inbox and messaging

Status: complete

- `Case`, `MessageThread`, `Message`, `SLATimer`, and queue routing
- WhatsApp webhook ingestion and outbound delivery tracking
- Agent workspace with real-time queue updates

## Chunk 007: Storefront and client portal

Status: complete

- Public tenant storefront pages
- Self-service booking visibility and payment status pages
- Group leader and customer portal surfaces

## Chunk 008: Reporting and live operations

Status: in progress

- KPI cards, exports, and dashboards
- Turbo Streams / AnyCable live refresh patterns
- Read-optimized reporting queries and scheduled metric snapshots
