#!/usr/bin/env python3
"""Run the claims pipeline end to end: load_raw -> dbt run -> dbt test."""
import logging
import subprocess
import sys
from pathlib import Path

import duckdb

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler("logs/pipeline.log")],
)
log = logging.getLogger(__name__)


def run(cmd):
    log.info("running: %s", " ".join(cmd))
    subprocess.run(cmd, check=True)


def load_raw():
    log.info("stage 1/3: load_raw")
    con = duckdb.connect("claims.duckdb")
    for f in sorted(Path("data").glob("data_*.csv")):
        table = f.stem.replace("data_", "")
        con.execute(f"CREATE OR REPLACE TABLE raw_{table} AS SELECT * FROM read_csv_auto('{f}', header=true)")
        n = con.execute(f"SELECT count(*) FROM raw_{table}").fetchone()[0]
        log.info("  raw_%s: %d rows", table, n)
    con.close()


def main():
    Path("logs").mkdir(exist_ok=True)
    try:
        load_raw()
        run(["dbt", "run", "--project-dir", ".", "--profiles-dir", "."])
        run(["dbt", "test", "--project-dir", ".", "--profiles-dir", "."])
    except Exception as e:
        log.exception("pipeline failed: %s", e)
        sys.exit(1)
    log.info("pipeline ok")


if __name__ == "__main__":
    main()
