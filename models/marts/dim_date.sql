WITH spine AS (
    SELECT cast(d AS date) AS date_key
    FROM
        generate_series(
            date '2026-01-01', date '2026-12-31', interval '1 day'
        ) AS t (d)
)

SELECT
    date_key,
    cast(extract('year' FROM date_key) AS integer) AS year,
    cast(extract('quarter' FROM date_key) AS integer) AS quarter,
    cast(extract('month' FROM date_key) AS integer) AS month_num,
    cast(date_trunc('month', date_key) AS date) AS month_start_date,
    strftime(date_key, '%B') AS month_name
FROM spine
