with spine as (
    select cast(d as date) as date_key
    from generate_series(date '2026-01-01', date '2026-12-31', interval '1 day') as t(d)
)

select
    date_key,
    extract('year' from date_key)::integer as year,
    extract('quarter' from date_key)::integer as quarter,
    extract('month' from date_key)::integer as month_num,
    date_trunc('month', date_key)::date as month_start_date,
    strftime(date_key, '%B') as month_name
from spine