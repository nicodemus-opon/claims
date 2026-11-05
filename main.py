import duckdb
from pathlib import Path
con = duckdb.connect("claims.duckdb")
# Specify the directory path
dir_path = Path('data')

# Get all items that are strictly files
files = [f for f in dir_path.iterdir() if f.is_file() & str(f).endswith('.csv')]

for file in files:
    table = str(file).split('.')[0].split('/')[1].split('data_')[1]
    print(table)
    con.execute(f"""
        CREATE OR REPLACE TABLE {table} AS
        SELECT * FROM read_csv_auto('{file}', header=true)
    """)
