SELECT
    scheme_id,
    scheme_name,
    payer_name,
    plan_tier
FROM {{ ref('stg_schemes') }}
