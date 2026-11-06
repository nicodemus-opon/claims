-- Custom check: append-only status log should not re-emit the same terminal status
-- consecutively (paid->paid, approved->approved, rejected->rejected). These are
-- duplicate events that int_claim_current_status masks via row_number(); surfacing
-- them as a warning keeps the run green while flagging the source issue.
{{ config(severity='warn') }}

with ordered as (
    select
        claim_id,
        event_id,
        status,
        lag(status) over (partition by claim_id order by changed_at, event_id) as prev_status
    from {{ ref('stg_claim_status_events') }}
)
select
    claim_id,
    event_id,
    status
from ordered
where status in ('approved', 'rejected', 'paid')
  and status = prev_status