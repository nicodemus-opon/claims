-- Q8. Rejection rate by plan tier and provider type.
SELECT
    s.plan_tier,
    p.provider_type,
    count(*) AS claims,
    sum(
        CASE WHEN f.current_status = 'rejected' THEN 1 ELSE 0 END
    ) AS rejected,
    round(
        100.0 * sum(
            CASE WHEN f.current_status = 'rejected' THEN 1 ELSE 0 END
        ) / count(*), 2
    ) AS rejection_rate_pct
FROM {{ ref('fct_claims') }} f
INNER JOIN {{ ref('dim_scheme') }} s
    ON f.scheme_id = s.scheme_id
INNER JOIN {{ ref('dim_provider') }} p
    ON f.provider_id = p.provider_id
GROUP BY s.plan_tier, p.provider_type
ORDER BY rejection_rate_pct DESC
