-- Q1. Approved spend by provider county, Q1 2026, counties with >= 10 claims.
SELECT
    p.county AS provider_county,
    count(*) AS claim_count,
    sum(f.approved_amount) AS approved_spend
FROM {{ ref('fct_claims') }} f
INNER JOIN {{ ref('dim_provider') }} p
    ON f.provider_id = p.provider_id
INNER JOIN {{ ref('dim_date') }} d
    ON f.service_date = d.date_key
WHERE
    d.year = 2026
    AND d.quarter = 1
GROUP BY p.county
HAVING count(*) >= 10
ORDER BY approved_spend DESC
