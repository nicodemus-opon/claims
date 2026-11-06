WITH ranked AS (
    SELECT
        claim_id,
        status,
        changed_at,
        changed_by,
        event_id,
        row_number() OVER (
            PARTITION BY claim_id
            ORDER BY changed_at DESC, event_id DESC
        ) AS rn
    FROM {{ ref('stg_claim_status_events') }}
)

SELECT
    claim_id,
    status AS current_status,
    changed_at AS status_changed_at,
    changed_by AS status_changed_by,
    event_id AS current_event_id
FROM ranked
WHERE rn = 1
