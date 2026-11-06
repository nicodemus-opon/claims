SELECT
    cast(provider_id AS integer) AS provider_id,
    cast(provider_name AS varchar) AS provider_name,
    cast(provider_type AS varchar) AS provider_type,
    cast(kmpdc_level AS integer) AS kmpdc_level,
    upper(trim(cast(county AS varchar))) AS county
FROM {{ source('claims_raw', 'raw_providers') }}
