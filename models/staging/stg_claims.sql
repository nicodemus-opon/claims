SELECT
    cast(claim_id AS integer) AS claim_id,
    cast(member_id AS integer) AS member_id,
    cast(provider_id AS integer) AS provider_id,
    cast(service_date AS date) AS service_date,
    cast(submitted_at AS timestamp) AS submitted_at,
    cast(claim_amount AS decimal(12, 2)) AS claim_amount,
    cast(approved_amount AS decimal(12, 2)) AS approved_amount,
    cast(currency AS varchar) AS currency,
    CASE
        WHEN approved_amount = 0
            THEN
                'REJECTED'
        WHEN approved_amount IS NULL
            THEN
                'AWAITING'
        WHEN approved_amount > 0
            THEN
                'APPROVED'
    END AS approval_status
FROM {{ source('claims_raw', 'raw_claims') }}
