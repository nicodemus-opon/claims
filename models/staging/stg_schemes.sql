select
    cast(scheme_id as integer) as scheme_id,
    cast(scheme_name as varchar) as scheme_name,
    cast(payer_name as varchar) as payer_name,
    cast(plan_tier as varchar) as plan_tier
from {{ source('claims_raw', 'raw_schemes') }}
