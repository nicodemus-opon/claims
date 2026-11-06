-- Q4. Top 3 providers by approved spend per member county (ties share rank).
WITH ranked AS (
    SELECT
        m.county AS member_county,
        p.provider_id,
        p.provider_name,
        sum(f.approved_amount) AS approved_spend,
        dense_rank() OVER (
            PARTITION BY m.county
            ORDER BY sum(f.approved_amount) DESC
        ) AS rnk
    FROM {{ ref('fct_claims') }} f
    INNER JOIN {{ ref('dim_member') }} m
        ON f.member_id = m.member_id
    INNER JOIN {{ ref('dim_provider') }} p
        ON f.provider_id = p.provider_id
    GROUP BY m.county, p.provider_id, p.provider_name
)

SELECT
    member_county,
    provider_id,
    provider_name,
    approved_spend,
    rnk
FROM ranked
WHERE rnk <= 3
ORDER BY member_county, rnk, provider_name
