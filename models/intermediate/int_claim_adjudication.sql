with first_decision as (
    select
        claim_id,
        min(changed_at) as adjudicated_at
    from {{ ref('stg_claim_status_events') }}
    where status in ('approved', 'rejected')
    group by claim_id
)

select
    c.claim_id,
    fd.adjudicated_at,
    case
        when fd.adjudicated_at is not null
        then date_diff('day', c.submitted_at, fd.adjudicated_at)
    end as turnaround_days
from {{ ref('stg_claims') }} c
left join first_decision fd on fd.claim_id = c.claim_id