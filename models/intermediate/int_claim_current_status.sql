with ranked as (
    select
        claim_id,
        status,
        changed_at,
        changed_by,
        event_id,
        row_number() over (
            partition by claim_id
            order by changed_at desc, event_id desc
        ) as rn
    from {{ ref('stg_claim_status_events') }}
)

select
    claim_id,
    status as current_status,
    changed_at as status_changed_at,
    changed_by as status_changed_by,
    event_id as current_event_id
from ranked
where rn = 1
