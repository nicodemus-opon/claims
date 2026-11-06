# Claims ELT (dbt + DuckDB)

dbt project that turns the operational CSV exports in `data/` into a small claims warehouse in `claims.duckdb`.

## Run

Requirements: Git + Python 3.9+ (tested on 3.9.6).

```bash
git clone https://github.com/nicodemus-opon/claims.git
cd claims
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 run_pipeline.py
```

`run_pipeline.py` loads `data/data_*.csv` into `raw_*` tables, runs dbt, then runs dbt tests. Output is `claims.duckdb`; logs go to `logs/pipeline.log`.

Useful checks:

```bash
dbt test --project-dir . --profiles-dir .
duckdb claims.duckdb "SELECT count(*) FROM fct_claims;"
```

## Data model

Layers: `raw_*` tables -> `stg_*` views -> `int_*` views -> mart tables. Mart materialization is configured in `dbt_project.yml`.

| Model | Grain | Notes |
|---|---|---|
| `fct_claims` | one row per `claim_id` | All submissions retained; duplicate detection is in `analysis/`, not this fact |
| `fct_claim_lines` | one row per `claim_line_id` | Joined to claim/member/provider/scheme context |
| `dim_member` | one row per `member_id` | Type 1 current values only |
| `dim_provider` | one row per `provider_id` | |
| `dim_scheme` | one row per `scheme_id` | |
| `dim_date` | one row per calendar date | Fixed 2026-01-01 to 2026-12-31 |

Intermediate models: `int_claim_current_status` (latest event per claim), `int_claim_adjudication` (first approved/rejected decision), `int_claim_line_totals` (line count and summed amounts).

## Assumptions and trade-offs

- `fct_claims.approval_status` is derived from `approved_amount`, not from status events.
- Current status uses the latest event by `changed_at`, then `event_id`.
- Adjudication uses the first `approved` or `rejected` event; `turnaround_days` is calendar days from `submitted_at`.
- `line_amount_mismatch` flags claims where `claim_amount` differs from summed `line_amount` by more than `0.01`.
- `int_claim_line_totals.lines_total_amount` sums stored `line_amount`; `lines_computed_amount` (`quantity * unit_price`) is also available.
- LEFT JOINs keep claims with missing member/provider/scheme references.
- County and status values are trimmed/uppercased or accepted-value tested; currency is assumed to be KES.
- DuckDB single-file warehouse, staging/intermediate as views, and full refresh keep the project easy to clone and run. No incremental or partitioned loads.

## With a week

- SCD2 dimensions via dbt snapshots; dynamic `dim_date` from min/max service date.
- Incremental marts keyed by `claim_id` / `service_date`.
- More singular tests: PK uniqueness/not-null on every mart, accepted ranges, reconciliation as an error where appropriate.
- Quarantine table for mismatched or invalid rows; seeds for casing/status mappings.
- Publish dbt docs and exposures.
- CI running `sqlfluff` and `dbt test`.

## At 1,000x volume

- Move raw storage and compute to a warehouse (BigQuery/Snowflake) or object storage plus compute.
- Incremental merge/upsert loads, clustered/partitioned by `service_date` and `claim_id`.
- Orchestrator with retries, freshness checks, and SLAs.
- Idempotent, deduplicated status-event ingestion and event sourcing for current status.
- Separate storage/compute and observability for data quality failures.

## Not finished

- Only two custom singular tests; most coverage is generated dbt tests.
- `dim_date` is hardcoded to 2026.
- Dimensions are Type 1 only.
- `analysis/` SQL is not materialized as models or exposures.
- No CI/CD, containerization, or published dbt docs.