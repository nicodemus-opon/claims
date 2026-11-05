select
    cast(event_id as integer) as event_id,
    cast(claim_id as integer) as claim_id,
    cast(status as varchar) as status,
    cast(changed_at as timestamp) as changed_at,
    cast(changed_by as varchar) as changed_by
from {{ source('claims_raw', 'raw_claim_status_events') }}
