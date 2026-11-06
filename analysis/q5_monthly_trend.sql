-- Q5. Monthly approved spend per scheme, MoM % change and running total.
WITH months AS (
    SELECT DISTINCT month_start_date
    FROM {{ ref('dim_date') }}
    WHERE year = 2026
),

monthly AS (
    SELECT
        m.month_start_date,
        s.scheme_id,
        s.scheme_name,
        coalesce(
            sum(
                CASE
                    WHEN f.current_status IN ('approved', 'paid')
                        THEN f.approved_amount
                END
            ), 0
        ) AS approved_spend
    FROM months m
    CROSS JOIN {{ ref('dim_scheme') }} s
    LEFT JOIN {{ ref('fct_claims') }} f
        ON
            f.scheme_id = s.scheme_id
            AND f.service_date >= m.month_start_date
            AND f.service_date < m.month_start_date + INTERVAL '1 month'
    GROUP BY m.month_start_date, s.scheme_id, s.scheme_name
),

with_lag AS (
    SELECT
        month_start_date,
        scheme_id,
        scheme_name,
        approved_spend,
        lag(approved_spend) OVER (
            PARTITION BY scheme_id
            ORDER BY month_start_date
        ) AS prev_spend
    FROM monthly
)

SELECT
    month_start_date,
    scheme_name,
    approved_spend,
    prev_spend,
    CASE
        WHEN prev_spend IS NULL OR prev_spend = 0 THEN NULL
        ELSE round(
            100.0 * (approved_spend - prev_spend) / prev_spend, 2
        )
    END AS mom_pct_change,
    sum(approved_spend) OVER (
        PARTITION BY scheme_id
        ORDER BY month_start_date
    ) AS running_total
FROM with_lag
ORDER BY scheme_name, month_start_date
