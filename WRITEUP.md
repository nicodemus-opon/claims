# Write-up

## Data model and why

Pipeline is `raw_*` → `stg_*` views → `int_*` views → mart tables, ending in a star schema with `fct_claims` (one row per claim, all submissions kept) and `fct_claim_lines` joined to member, provider, scheme, and date dims. Staging cleans and casts, marts stay simple tables for clone-and-run on one DuckDB file, and joins are LEFT so missing references never drop claims. The three intermediate views isolate the tricky logic:

- `int_claim_current_status`: latest event per claim, tie-broken by `event_id`.
- `int_claim_adjudication`: first approved/rejected event, for `turnaround_days`.
- `int_claim_line_totals`: line count and sums, keeping both stored and computed (`quantity * unit_price`) totals.

## Hardest problem and resolution

Status events mixed up latest status with first adjudication decision, and `changed_at` ties made results nondeterministic. I split them into `int_claim_current_status` (latest, tie-broken by `event_id`) and `int_claim_adjudication` (first approved/rejected for `turnaround_days`). Claim and line amounts also disagreed, so I kept both totals and added a `line_amount_mismatch` flag (0.01 tolerance) instead of silently picking one.

## One thing I'm not happy with

`dim_date` is hardcoded to 2026 and dimensions are Type 1 with no snapshots, so out-of-range claims won't join and history is lost; `analysis/` SQL is also untested and unmaterialized.
