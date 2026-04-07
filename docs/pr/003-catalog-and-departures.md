# PR 003: Catalog and Departures

## Summary

This chunk moves the application beyond tenant setup into the first operational domain: the travel catalog.

## Included changes

- Added tenant-owned `Product` and `Departure` models with core validations and lifecycle enums.
- Added tenant-scoped catalog routes, controllers, policies, and views.
- Added product creation and detail pages inside the tenant workspace.
- Added nested departure creation from a product page.
- Seeded one demo product and one demo departure for the demo tenant.
- Added integration coverage for:
  - product listing isolation
  - product creation
  - departure creation

## Audit notes

- This slice focuses on the minimum catalog backbone. `InventoryBucket`, `AddOn`, and `PricingRule` are still deferred.
- Pricing is currently stored as `base_price_cents` on the product record. More complex per-departure or rule-based pricing belongs in a later chunk.

## Verification

```bash
bin/rails db:migrate
bin/rails db:seed
bin/rails test
bin/rails zeitwerk:check
bin/rails runner 'puts({tenants: Tenant.count, products: Product.count, departures: Departure.count}.inspect)'
```

Manual smoke test:

1. Start the app with `bin/dev`.
2. Sign in at `http://demo.lvh.me:3000/users/sign_in`.
3. Open `/products`.
4. Create a new product and then add a departure from the product page.
