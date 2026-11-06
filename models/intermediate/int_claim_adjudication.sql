WITH first_decision AS (
    SELECT
        claim_id,
        min(changed_at) AS adjudicated_at
    FROM {{ ref('stg_claim_status_events') }}
    WHERE status IN ('approved', 'rejected')
    GROUP BY claim_id
)

SELECT
    c.claim_id,
    fd.adjudicated_at,
    CASE
        WHEN fd.adjudicated_at IS NOT NULL
            THEN date_diff('day', c.submitted_at, fd.adjudicated_at)
    END AS turnaround_days
FROM {{ ref('stg_claims') }} c
LEFT JOIN first_decision fd ON c.claim_id = fd.claim_id
