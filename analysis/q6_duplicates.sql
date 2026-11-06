-- Q6. Suspected duplicate submissions (same member/provider/date/amount).
SELECT
    member_id,
    provider_id,
    service_date,
    claim_amount,
    count(*) AS submissions,
    min_by(claim_id, submitted_at) AS keep_claim_id,
    string_agg(
        claim_id::VARCHAR, ',' ORDER BY submitted_at, claim_id
    ) AS claim_ids
FROM {{ ref('fct_claims') }}
GROUP BY member_id, provider_id, service_date, claim_amount
HAVING count(*) > 1
ORDER BY submissions DESC, service_date DESC
