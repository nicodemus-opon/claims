-- Q2. Scheme utilisation: enrolled members vs those who never claimed.
WITH claimed_members AS (
    SELECT DISTINCT member_id
    FROM {{ ref('fct_claims') }}
)

SELECT
    s.scheme_id,
    s.scheme_name,
    count(DISTINCT m.member_id) AS total_enrolled_members,
    count(DISTINCT CASE WHEN c.member_id IS NULL THEN m.member_id END)
        AS members_with_no_claim,
    CASE
        WHEN count(DISTINCT m.member_id) = 0 THEN NULL
        ELSE round(
            100.0
            * count(DISTINCT CASE WHEN c.member_id IS NULL THEN m.member_id END)
            / count(DISTINCT m.member_id), 2
        )
    END AS pct_members_with_no_claim
FROM {{ ref('dim_scheme') }} s
LEFT JOIN {{ ref('dim_member') }} m
    ON m.scheme_id = s.scheme_id
LEFT JOIN claimed_members c
    ON c.member_id = m.member_id
GROUP BY s.scheme_id, s.scheme_name
ORDER BY pct_members_with_no_claim DESC NULLS LAST
