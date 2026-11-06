SELECT
    provider_id,
    provider_name,
    provider_type,
    county,
    kmpdc_level
FROM {{ ref('stg_providers') }}
