-- Custom check: append-only status log should not re-emit the same terminal status
-- consecutively (paid->paid, approved->approved, rejected->rejected). These are
-- duplicate events that int_claim_current_status masks via row_number(); surfacing
-- them as a warning keeps the run green while flagging the source issue.
{{ config(severity='warn') }}

WITH ordered AS (
    SELECT
        claim_id,
        event_id,
        status,
        lag(status)
            OVER (PARTITION BY claim_id ORDER BY changed_at, event_id)
            AS prev_status
    FROM {{ ref('stg_claim_status_events') }}
)

SELECT
    claim_id,
    event_id,
    status
FROM ordered
WHERE
    status IN ('approved', 'rejected', 'paid')
    AND status = prev_status
