SELECT
    cast(event_id AS integer) AS event_id,
    cast(claim_id AS integer) AS claim_id,
    cast(status AS varchar) AS status,
    cast(changed_at AS timestamp) AS changed_at,
    cast(changed_by AS varchar) AS changed_by
FROM {{ source('claims_raw', 'raw_claim_status_events') }}
