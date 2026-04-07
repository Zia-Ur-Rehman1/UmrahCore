# PR 001: Foundation Bootstrap

## Summary

This chunk establishes the executable base for UmrahOps Pro as a Rails monolith instead of leaving the repository at the spec stage.

## Included changes

- Generated the Rails application with PostgreSQL, Hotwire, Tailwind, and importmap.
- Added `devise` and `pundit` as the baseline security dependencies.
- Configured the app for a Docker-backed PostgreSQL workflow through `config/database.yml`.
- Added a GitHub Actions workflow that boots PostgreSQL, prepares the database, and runs the test suite.
- Replaced the placeholder README with runnable setup, verification, and demo instructions.

## Audit notes

- The environment only had Rails `7.0.10` installed, so the codebase was scaffolded on Rails 7 instead of blocking on a missing Rails 8 toolchain.
- Minitest was pinned to `~> 5.25` because the local Ruby environment pulled `minitest 6`, which is incompatible with Rails 7.0’s built-in test runner.

## Verification

```bash
bin/rails db:create db:migrate
bin/rails test
bin/rails zeitwerk:check
```
