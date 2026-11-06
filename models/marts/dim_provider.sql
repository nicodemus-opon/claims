select
    provider_id,
    provider_name,
    provider_type,
    county,
    kmpdc_level
from {{ ref('stg_providers') }}