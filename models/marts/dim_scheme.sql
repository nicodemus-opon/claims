select
    scheme_id,
    scheme_name,
    payer_name,
    plan_tier
from {{ ref('stg_schemes') }}