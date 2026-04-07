# PR 006: Support Inbox and Storefront

## Summary

This chunk completes the basic customer-facing and servicing surfaces required for an MVP walkthrough.

## Included changes

- Added public tenant storefront rendering on tenant root hosts for signed-out visitors.
- Added `SupportCase` and `CaseMessage` models.
- Added case creation, assignment, conversation view, and reply flow.
- Added dashboard aggregates for bookings, payments, balances, and open cases.
- Added live demo users for finance and support roles.

## Verification

```bash
bin/rails test test/integration/support_flow_test.rb test/integration/storefront_flow_test.rb
bin/rails runner 'puts({cases: SupportCase.count, case_messages: CaseMessage.count}.inspect)'
```

Manual smoke test:

1. Visit `http://demo.lvh.me:3000/` while signed out and confirm the storefront renders.
2. Sign in as `support@demotravels.test`.
3. Open a case from `/support_cases/new`.
4. Reply from the case detail page and confirm the conversation updates.
