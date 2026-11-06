-- Q7. Median adjudication turnaround days by provider type.
SELECT
    p.provider_type,
    median(f.turnaround_days) AS median_turnaround_days,
    count(*) AS adjudicated_claims
FROM {{ ref('fct_claims') }} f
INNER JOIN {{ ref('dim_provider') }} p
    ON f.provider_id = p.provider_id
WHERE f.adjudicated_at IS NOT NULL
GROUP BY p.provider_type
ORDER BY median_turnaround_days ASC
