# Data Engineering Assessment — Starter

This repository contains the raw data for the take-home assessment. Everything else is yours to build.

Read the assessment brief you were sent before you start. It describes what to build, how it is graded, and what to submit.

## What's here

```
data/
  data_schemes.csv              5 rows
  data_members.csv            200 rows
  data_providers.csv           12 rows
  data_claims.csv             530 rows
  data_claim_lines.csv      1,330 rows
  data_claim_status_events.csv  1,768 rows
  schema.sql                  reference DDL for all six tables
```

`schema.sql` is provided for reference. You are not required to use it, and you may model the raw layer however you prefer.

## Getting started

The reference setup is DuckDB, which needs no server and no account:

```bash
python -m venv .venv && source .venv/bin/activate
pip install duckdb
```

Loading the CSVs is then a one-liner per table:

```python
import duckdb
con = duckdb.connect("claims.duckdb")
con.execute("""
    CREATE OR REPLACE TABLE raw_claims AS
    SELECT * FROM read_csv_auto('data/data_claims.csv', header=true)
""")
```

Or from the DuckDB CLI:

```sql
CREATE OR REPLACE TABLE raw_claims AS
SELECT * FROM read_csv_auto('data/data_claims.csv', header=true);
```

PostgreSQL, BigQuery, Snowflake or anything else is equally acceptable. Make your setup reproducible from a clean clone and document it in your README.

## A note on the CSVs

They are exports from an operational system, not a cleaned dataset. Empty strings, inconsistent casing and values that disagree with each other are all present and all intentional. Handling them is part of the task.

## What to replace this file with

Delete this README and write your own. The brief describes what it should cover.
