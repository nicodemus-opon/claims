SELECT
    cast(scheme_id AS integer) AS scheme_id,
    cast(scheme_name AS varchar) AS scheme_name,
    cast(payer_name AS varchar) AS payer_name,
    cast(plan_tier AS varchar) AS plan_tier
FROM {{ source('claims_raw', 'raw_schemes') }}
