select
    cast(provider_id as integer) as provider_id,
    cast(provider_name as varchar) as provider_name,
    cast(provider_type as varchar) as provider_type,
    cast(county as varchar) as county,
    cast(kmpdc_level as integer) as kmpdc_level
from {{ source('claims_raw', 'raw_providers') }}
