# PR 005: Payments and Ledger

## Summary

This chunk adds manual payment capture and ledger posting on top of the booking workflow.

## Included changes

- Added `Payment` and `LedgerEntry` models.
- Added `Payments::Recorder` to:
  - persist the payment
  - update booking balance state
  - append a ledger entry
- Added payment capture UI from the booking detail page.
- Added finance-oriented fixture data and integration coverage.

## Verification

```bash
bin/rails test test/integration/finance_flow_test.rb
bin/rails runner 'puts Booking.select(:booking_ref, :amount_paid_cents, :outstanding_cents).map(&:attributes).inspect'
```

Manual smoke test:

1. Open a booking detail page.
2. Record a payment from `/bookings/:id/payments/new`.
3. Confirm booking status and outstanding balance update.
4. Confirm the ledger panel shows a posted entry.
