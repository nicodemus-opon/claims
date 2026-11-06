-- Q3. Approved vs billed totals per provider (fct_claims only, no fan-out).
SELECT
    p.provider_id,
    p.provider_name,
    count(*) AS claim_count,
    sum(f.approved_amount) AS approved_total,
    sum(f.lines_total_amount) AS billed_total
FROM {{ ref('fct_claims') }} f
INNER JOIN {{ ref('dim_provider') }} p
    ON f.provider_id = p.provider_id
GROUP BY p.provider_id, p.provider_name
ORDER BY approved_total DESC
