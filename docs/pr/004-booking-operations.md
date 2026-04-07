# PR 004: Booking Operations

## Summary

This chunk introduces the core booking workflow for tenant operators.

## Included changes

- Added `Booking` and `Traveler` models with tenant ownership, validations, and lifecycle enums.
- Added a booking creation service that computes pricing from the chosen product and traveler count.
- Added booking index, detail, and creation screens.
- Added traveler add-on flow from the booking detail page.
- Linked bookings to products, departures, payments, and support cases.

## Verification

```bash
bin/rails test test/integration/booking_flow_test.rb
bin/rails runner 'puts Booking.order(:id).pluck(:booking_ref, :status).inspect'
```

Manual smoke test:

1. Sign in at `http://demo.lvh.me:3000/users/sign_in`.
2. Open `/bookings/new`.
3. Create a booking against `Premium Spring Umrah`.
4. Add a traveler from the booking detail page.
